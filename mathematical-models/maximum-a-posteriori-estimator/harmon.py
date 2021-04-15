from common import *

"""
	HARMONIC utils
"""

def harmon_feature_function(X, degree=3, center=175.0, scale=90.0, free_term=60):
	n = len(X)	
	X = (X - center) / scale

	phi = []
	phi.append(np.array([free_term for _ in range(n)]))
	for k in range(1, degree + 1):
		phi.append(np.cos((2*np.pi*k) * X))
		phi.append(np.sin((2*np.pi*k) * X))
	return np.matrix(phi).T


"""
	The Maximum Likelihood parameter generator.
"""

def mle_w(X, Y, degree):
	# Compute the pseudo-inverse (Moore-Penrose).
	phi = harmon_feature_function(X, degree)
	moore_pensore = np.linalg.pinv(phi)

	# Obtain the parameters w optimum.
	w_opt = np.dot(moore_pensore, Y.reshape(Y.shape[0], 1))
	return w_opt


"""
	The Maximum Prior parameter generator.
"""

def map_w(X, Y, degree):
	sig_theta = 50000
	sig_noise = 1

	phi = harmon_feature_function(X, degree)
	icov_theta = ((sig_noise/sig_theta)**2) * np.eye(2*degree+1, 2*degree+1)
	w_opt = np.dot(np.linalg.pinv(np.dot(phi.T, phi) + icov_theta), np.dot(phi.T, Y.reshape(Y.shape[0], 1)))
	return w_opt


"""
	A series of experiments regarding harmonic based estimations of data underlying nature.
"""

def harmon_based_estimator(X, Y, degree):

	current_figure = plt.figure(degree)
	current_figure.set_size_inches(9,6)

	# Scatter the points.
	plt.scatter(X, Y, c = ['#9467bd'], alpha = 0.5, marker = 'o', 
		label = 'Some data points between 140 and 210.')
	plt.xlabel('Height')
	plt.ylabel('Weight')

	estimator(map_w, harmon_feature_function, X, Y, degree, clr='#fa3c16', lbl='Maximum Prior Estimator')
	estimator(mle_w, harmon_feature_function, X, Y, degree, clr='#2dfc68', lbl='Maximum Likelihood Estimator')

	return current_figure


def harmon_based_estimator_nrmse(X, Y, degree):

	estm_01 = estimator_val(map_w, harmon_feature_function, X, Y, degree).tolist()
	estm_02 = estimator_val(mle_w, harmon_feature_function, X, Y, degree).tolist()

	estm_01 = rmse([item for sublist in estm_01 for item in sublist], Y)
	estm_02 = rmse([item for sublist in estm_02 for item in sublist], Y)

	return [estm_01, estm_02]


