import matplotlib.pyplot as plt
import numpy as np


"""
	COMMON GROUNDS

	I made an estimator framework with a slot for connecting the desired parameter generator, and the features
	generator, so it can be used with either polynomial or harmonic features and parameters optimized.
"""

def estimator(w_func, features, X, Y, degree, params=None, clr='purple', lbl='', debug=False):
	# Obtain the parameters w optimum.
	if params is not None:
		w_opt = w_func(X, Y, degree, params)
	else:
		w_opt = w_func(X, Y, degree)

	# Generate random data on which we'll use the parameters
	# discovered above. The idea is to have unknown inputs
	# and outputs.
	some_Xs = np.arange(140, 210, 0.1)
	if params is not None:
		their_Ys = features(some_Xs, degree, params) * w_opt
	else:
		their_Ys = features(some_Xs, degree) * w_opt

	plt.plot(some_Xs, their_Ys, 'k-', color = clr, 
		label=lbl + '(poly degree: ' + str(degree) + ')')
	plt.legend(loc='upper left')

	# Add the prediction.
	plt.plot(some_Xs, their_Ys, 'k-', color=clr)
	plt.xlim(135, 200)
	plt.ylim(35, 120)

	if debug: 
		print(features(some_Xs, degree, params))
		print(w_opt)

def estimator_val(w_func, features, X, Y, degree, params=None, debug=False):
	# Obtain the parameters w optimum.
	if params is not None:
		w_opt = w_func(X, Y, degree, params)
	else:
		w_opt = w_func(X, Y, degree)

	# Generate random data on which we'll use the parameters
	# discovered above. The idea is to have unknown inputs
	# and outputs.
	if params is not None:
		their_Ys = features(X, degree, params) * w_opt
	else:
		their_Ys = features(X, degree) * w_opt

	if debug: 
		print(features(X, degree, params))
		print(w_opt)

	return their_Ys


def show_figs(figs):
	# for fig in figs:
	plt.show()

	# Enjoy the graph with  a quick hack that keeps the figures alive.
	# input("Submit any character to close the current figures...")

	# plt.close('all')

def rmse(predictions, targets):
    return np.sqrt(((predictions - targets) ** 2).mean()) / np.mean(targets)
    