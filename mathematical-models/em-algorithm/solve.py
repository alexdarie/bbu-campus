from utils import *
from math import sqrt, pi
from copy import deepcopy

"""
EM Algorithm

Before starting the algorithm, initialize the params. Then,
the algorithm has two steps, repeated until convergence:
	a. in the E step it tries to guess the values of the z[i]
	b. in the M step it updates the params of our model based
	on our guesses
"""

def init(data, n, m, num_clusters):
	params = {
		'clusters centroids': [],
		'clusters covariance matrices': [],
		'clusters probabilities': []
	}

	for i in range(num_clusters):
		# params['clusters centroids'].append(data[i])
		params['clusters centroids'].append(data[(i + 1) * 50])
		params['clusters covariance matrices'].append(cov_mtrx(m))
		params['clusters probabilities'].append(1 / num_clusters)

	params = convert_to_numpy_params(params)
	return params


def guess_w(data, n, num_clusters, params):
	"""
	w[i][j] is how much x[i] is assigned to mu[j] Gaussian.

	return:
		A vector w containing our current best guess for the ith cluster's weights.
	"""
	w = init_w(n, num_clusters)
	for i in range(num_clusters):
		z = data - params['clusters centroids'][i]
		d = np.sum(np.dot(z, np.linalg.inv(params['clusters covariance matrices'][i])) * z, axis=1)
		w[i] = params['clusters probabilities'][i] * np.exp(-d/2) / \
				sqrt(np.linalg.det(2 * pi * params['clusters covariance matrices'][i]))

	w = np.matrix(w)
	w = w / np.sum(w, axis=0)
	return w
	

def compute_params(data, m, w, num_clusters):
	new_params = {
		'clusters centroids': zero_centroids(m, num_clusters),
		'clusters covariance matrices': zero_covariance_matrices(m, num_clusters),
		'clusters probabilities': zero_probabilities(num_clusters)
	}
	total_probability = np.sum(w)

	for i in range(num_clusters):
		new_params['clusters centroids'][i] = np.sum(np.multiply(data, w[i].T), axis=0) / np.sum(w[i])
		tmp = data - new_params['clusters centroids'][i]
		new_params['clusters covariance matrices'][i] = np.dot(tmp.T, np.multiply(tmp, w[i].T)) / np.sum(w[i])
		new_params['clusters probabilities'][i] = np.sum(w[i]) / total_probability

	new_params = convert_to_numpy_params(new_params)
	return new_params


def em(num_iterations, data, n, m, num_clusters):
	params = init(data, n, m, num_clusters)
	for i in range(num_iterations + 1):
		last_guess = guess_w(data, n, num_clusters, params)
		new_params = compute_params(data, m, last_guess, num_clusters)
		params = new_params

	return params, last_guess


"""
	Improvements on the EM Algorithm.
"""


def em_2nd_stage(num_iterations, data, n, m, num_clusters, params):
	"""
	This em implementation no longer initializes the params, but uses those given
	as an argument to the function. The expected behavior is that a centroid jammed
	was moved in the vecity of a loose centroid, so that the algorithm does not
	remain stuck in the last configuration of centroids.
	"""
	for i in range(num_iterations + 1):
		last_guess = guess_w(data, n, num_clusters, params)
		new_params = compute_params(data, m, last_guess, num_clusters)
		params = new_params

	return params, last_guess


def measures_condensed_nature_of_clusters(last_guess, data, num_clusters, params):
	"""
	Storing kind of a meta-data for each cluster, structred as a dict with:
		data - list of points (3D/2D and so on)
		std_dev - standard deviation from the centroid
	"""

	clusters_meta = {}
	for i in range(num_clusters):
		clusters_meta[i] = {'data': [], 'std_dev': -1}

	i = 0
	for cls_id in np.argmax(last_guess.T, axis = 1):
		cls_id = np.asarray(cls_id)[0][0]
		clusters_meta[cls_id]['data'].append(np.asarray(data)[i])
		i += 1

	for i in range(num_clusters):
		clusters_meta[i]['std_dev'] = np.mean(np.linalg.norm(clusters_meta[i]['data'] - params['clusters centroids'][i]))

	return clusters_meta


def loosest_cluster(clusters_meta, num_clusters):
	"""
	Given the standard deviation from the centroid:
		select the cluster with highest value, because a high standard deviation 
		indicates that the values are spread out over a wider range.
	"""

	cls_id = 0
	maxim = clusters_meta[0]['std_dev']
	for i in range(1, num_clusters):
		if clusters_meta[i]['std_dev'] > maxim:
			maxim = clusters_meta[i]['std_dev']
			cls_id = i
	return cls_id


def jammed_clusters(params, num_clusters):
	"""
		Returns a list of Kullback-Leibler divergence value for every two clusters
		i, j, using the cluster centroid and the covariance matrix.
	"""

	jammed_clusters = [
		[KL(params['clusters centroids'][i], 
			params['clusters covariance matrices'][i], 
			params['clusters centroids'][j], 
			params['clusters covariance matrices'][j]), i, j]
		for i in range(num_clusters) 
		for j in range(i+1, num_clusters)
	]

	jammed_clusters.sort(key=lambda x: x[0])

	return jammed_clusters


def KL(centroid1, cov1, centroid2, cov2):
	"""
		Kullback-Leibler divergence value for two clusters.
	"""
	dm = centroid1 - centroid2
	comp1 = np.log(np.linalg.det(np.dot(cov2, np.linalg.inv(cov1))))
	comp2 = np.trace(np.dot((cov2 - cov1), np.linalg.inv(cov2)))
	comp3 = np.dot((np.dot(dm, np.linalg.inv(cov2))), dm.T)
	diverg = np.asarray((comp1 - comp2 + comp3) / 2)[0][0]
	return diverg


def move_to_vecinity(jammed_cluster, loose_cluster, m, params):
	new_params = deepcopy(params)
	new_params['clusters centroids'][jammed_cluster] = new_params['clusters centroids'][loose_cluster]

	# reset their covariance matrices to let them move around again
	new_params['clusters covariance matrices'][jammed_cluster] = cov_mtrx(m)
	return new_params


def improved_em(num_iterations, data, n, m, num_clusters):
	"""
		Running the E-M steps will eventually get us stuck in a configuration of centroids out of which
		we cannot evade. One solution would be to spread de jammed centroids, one at a time, and move it 
		in the vecinity of a loose centroid.
			a. a loose centroid is similar to a shepard associated to more than one herd of sheep;
			b. a jammed centroid is similar to one that is competing with the others on handling the 
			same herd of sheeps;
		The following content described how to achieve such a movement of a jammed centroid towards the
		loose centroid until there is no need for such an operation.
	"""

	# compute params, then if centroids get jammed, follow (i), (ii), (iii)
	params, last_guess = em(num_iterations, data, n, m, num_clusters)
	print('first stage em results: ')
	centroids_pretty_print(params)

	jammed = True
	previous = [-1, -1]

	i = 0
	while jammed:

		# (i) Measures the pairwise distence between cluster centres and selects the closest pair
		jammed_clstrs = jammed_clusters(params, num_clusters)

		if len(jammed_clstrs) == 0:
			break
		
		jammed_cluster = jammed_clstrs[0][1]

		# (ii) Measures the condensed nature of clusters and the "loosest" one is selected
		clusters_meta = measures_condensed_nature_of_clusters(last_guess, data, num_clusters, params)
		loose_cluster = loosest_cluster(clusters_meta, num_clusters)

		if [loose_cluster, jammed_cluster] == previous:
			break

		# # (iii) One of the centres from (i) is moved to the vicinity of the centre of (ii)
		params = move_to_vecinity(jammed_cluster, loose_cluster, m, params)

		# Give them (params) another spin
		params, last_guess = em_2nd_stage(num_iterations, data, n, m, num_clusters, params)
		
		print('### epoch-{}: '.format(i))
		print('jammed id: {} | loose id: {}'.format(jammed_cluster, loose_cluster))
		print('norm: {}'.format([[clusters_meta[i]['std_dev'], len(clusters_meta[i]['data'])] for i in range(num_clusters)]))
		print('cent_clus = {}\n'.format(centroids_pretty(params)))

		previous = [loose_cluster, jammed_cluster]
		i += 1

	return params, last_guess

"""
	DEMOs
"""

def demo_em():
	points, n, m = read_points('3d_input.txt', '\t')
	params, last_guess = em(100, points, n, m, 4)

	# Course notes: pr_clus := [0.25419338929793495, 0.25274002788881794, 0.24760346138245778, 0.2454631214307893]
	print(params['clusters probabilities'])

def demo_improved_em():
	points, n, m = read_points('2d_input.txt', ' ')
	params, last_guess = improved_em(100, points, n, m, 6)

demo_improved_em()

