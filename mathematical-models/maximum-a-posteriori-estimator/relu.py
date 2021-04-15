from common import *

import random

from mpl_toolkits.mplot3d import Axes3D

"""
	ReLu utils
"""

def ReLu(x):
	for i in range(len(x)):
		x[i] = np.maximum(0, x[i])
	return x


def ReLu_feature_function(X, degree, params, free_term=65):
	n = len(X)	
	a = params['a']
	b = params['b']

	phi = []
	phi.append(np.array([free_term for _ in range(n)]))
	for k in range(1, degree+1):
		phi.append(ReLu(b[k] * (X - a[k])))
	return np.matrix(phi).T


def ReLu_feature_function_bone(X, degree, params, free_term=65):
	n = len(X)	
	a = params['a']

	phi = []
	phi.append(np.array([free_term for _ in range(n)]))
	for k in range(1, degree+1):
		phi.append(ReLu((X - a[k])))
	return np.matrix(phi).T


"""
	The Maximum Likelihood parameter generator.
"""

def mle_w(X, Y, degree, params):
	# Compute the pseudo-inverse (Moore-Penrose).
	phi = ReLu_feature_function(X, degree, params)
	moore_pensore = np.linalg.pinv(phi)

	# Obtain the parameters w optimum.
	w_opt = np.dot(moore_pensore, Y.reshape(Y.shape[0], 1))
	return w_opt


"""
	The Maximum Prior parameter generator.
"""

def map_w(X, Y, degree, params):
	a = params['a']
	b = params['b']

	w = np.random.randn(1, degree+1)[0]
	sig_theta = np.sqrt(np.mean(abs(w - np.mean(w))**2))
	sig_noise = np.sqrt(np.mean(abs(a - np.mean(a))**2))

	phi = ReLu_feature_function(X, degree, params)
	icov_theta = ((sig_noise/sig_theta)**2) * np.eye(degree+1, degree+1)
	w_opt = np.dot(np.linalg.pinv(np.dot(phi.T, phi) + icov_theta), np.dot(phi.T, Y.reshape(Y.shape[0], 1)))
	return w_opt


def map_w_bone(X, Y, degree, params):
	a = params['a']
	b = params['b']

	w = np.random.randn(1, degree+1)[0]
	sig_theta = np.sqrt(np.mean(abs(w - np.mean(w))**2))
	sig_noise = np.sqrt(np.mean(abs(a - np.mean(a))**2))

	phi = ReLu_feature_function_bone(X, degree, params)
	icov_theta = ((sig_noise/sig_theta)**2) * np.eye(degree+1, degree+1)
	w_opt = np.dot(np.linalg.pinv(np.dot(phi.T, phi) + icov_theta), np.dot(phi.T, Y.reshape(Y.shape[0], 1)))
	return w_opt


def map_w_lambda(X, Y, degree, params):
	a = params['a']
	b = params['b']
	lmbda = params['lambda']

	w = np.random.randn(1, degree+1)[0]

	phi = ReLu_feature_function(X, degree, params)
	icov_theta = lmbda * np.eye(degree+1, degree+1)
	w_opt = np.dot(np.linalg.pinv(np.dot(phi.T, phi) + icov_theta), np.dot(phi.T, Y.reshape(Y.shape[0], 1)))
	return w_opt

"""
	Shortcut params generator.
"""

def shortcut(X, Y, degree, params):
	return np.matrix(np.random.randn(1, degree+1)[0]).T

"""
	A series of experiments regarding ReLu based estimations of data underlying nature.
"""

def positive_or_negative():
    if random.random() < 0.5:
        return 1
    else:
        return -1

def ReLu_based_estimator(X, Y, degree, which=[True, True, True, True, False]):

	current_figure = plt.figure(degree)
	current_figure.set_size_inches(9,6)

	# Scatter the points.
	plt.scatter(X, Y, c = ['#9467bd'], alpha = 0.5, marker = 'o', 
		label = 'Some data points between 140 and 210.')
	plt.xlabel('Height')
	plt.ylabel('Weight')

	params_randn = {
		'a': [120 + 100 * x for x in np.random.rand(1, degree+1)[0]],
		'b': [positive_or_negative() for _ in range(degree+1)]
	}

	params_linspc = {
		'a': np.arange(120, 220, (99.0/degree)),
		'b': [positive_or_negative() for _ in range(degree+1)],
		'lambda': 0.01
	}

	if which[0]:
		estimator(map_w, ReLu_feature_function, X, Y, degree, params_randn, '#fa3c16', lbl='Maximum Prior Estimator with `a` randn ')
	if which[1]:
		estimator(map_w, ReLu_feature_function, X, Y, degree, params_linspc, '#ffa29c', lbl='Maximum Prior Estimator with `a` linspc ')
	if which[2]:
		estimator(map_w_lambda, ReLu_feature_function, X, Y, degree, params_linspc, 'blue', lbl='Maximum Prior Estimator with `a` linspc; lambda: ' + str(params_linspc['lambda']) + ' ')
	if which[3]:
		estimator(mle_w, ReLu_feature_function, X, Y, degree, params_randn, '#2dfc68', lbl='Maximum Likelihood Estimator ')
	if which[4]:
		estimator(map_w_bone, ReLu_feature_function_bone, X, Y, degree, params_linspc, 'blue', lbl='Maximum Prior Estimator with b=[1, ..., 1] ')
	return current_figure


def ReLu_based_estimator_nrmse(X, Y, degree):

	params_randn = {
		'a': [120 + 100 * x for x in np.random.rand(1, degree+1)[0]],
		'b': [positive_or_negative() for _ in range(degree+1)]
	}

	params_linspc = {
		'a': np.arange(120, 220, (99.0/degree)),
		'b': [positive_or_negative() for _ in range(degree+1)],
		'lambda': 0.3
	}

	estm_01 = estimator_val(map_w, ReLu_feature_function, X, Y, degree, params_randn).tolist()
	estm_02 = estimator_val(map_w, ReLu_feature_function, X, Y, degree, params_linspc).tolist()
	estm_03 = estimator_val(map_w_lambda, ReLu_feature_function, X, Y, degree, params_linspc).tolist()
	estm_04 = estimator_val(mle_w, ReLu_feature_function, X, Y, degree, params_randn).tolist()

	estm_01 = rmse([item for sublist in estm_01 for item in sublist], Y)
	estm_02 = rmse([item for sublist in estm_02 for item in sublist], Y)
	estm_03 = rmse([item for sublist in estm_03 for item in sublist], Y)
	estm_04 = rmse([item for sublist in estm_04 for item in sublist], Y)

	return [estm_01, estm_02, estm_03, estm_04]


def plot_err(X, Y):
	a = []; b = []; c = []

	l = np.arange(0.001,0.02,0.001); m = len(l)
	d = [i for i in range(1, 70)]; n = len(d)

	for degree in d:
		for lmbda in l:
			params_linspc = {
				'a': np.arange(120, 220, (25.0/degree)),
				'b': [positive_or_negative() for _ in range(degree+1)],
				'lambda': lmbda
			}
			params_randn = {
				'a': [120 + 100 * x for x in np.random.rand(1, degree+1)[0]],
				'b': [positive_or_negative() for _ in range(degree+1)],
				'lambda': lmbda
			}

			estm = estimator_val(map_w_lambda, ReLu_feature_function, X, Y, degree, params_randn).tolist()
			a.append(degree)
			b.append(lmbda)
			c.append(rmse([item for sublist in estm for item in sublist], Y))

	x = np.reshape(a, (m, n))
	y = np.reshape(b, (m, n))
	z = np.reshape(c, (m, n))

	fig = plt.figure()
	fig.set_size_inches(11,8)
	ax = fig.add_subplot(111, projection='3d')

	ax.scatter3D(x, y, z, c=z, cmap='cividis')
	# ax.plot_trisurf(x, y, z, cmap='viridis', edgecolor='none');
	# ax.plot_surface(x, y, z, cmap='cividis')

	ax.set_xlabel('Degree')
	ax.set_ylabel('Lambda')
	ax.set_zlabel('NRMSE')

	plt.show()

