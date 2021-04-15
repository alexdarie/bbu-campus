import matplotlib.pyplot as plt
import numpy as np

from poly import *
from harmon import *
from relu import *

import matplotlib.animation as animation

fig = plt.figure()

"""
	Define the set of points we are working with.
"""

v = {
    'height': [148, 151, 150, 168, 160, 162, 188, 193, 141, 184, 192, 176, 183, 172, 178, 181, 181, 175, 194],
    'weight': [61, 58, 64, 65, 55, 57, 100, 91, 46, 85, 112, 77, 83, 64, 100, 92, 86, 88, 88]
}


"""
	EXPERIMENTS
	Run the experiemnts.
"""

def poly_graphs():

	figs = []

	# For the following degrees of the polynomials, compute the estimation.
	for i in [4, 7, 10, 13, 15, 19]:
		poly_based_estimator(np.array(v['height']), np.array(v['weight']), i)

	show_figs(figs)

def poly_nrmse():

	# For the following degrees of the polynomials, compute the nrmse.
	
	print('NRMSE: ')
	
	for i in [4, 7, 10, 13, 15, 19]:
		estms = poly_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)
		print('Poly feature function; degree: ' + str(i))
		print('MAP estimator; \t' + str(estms[0]))
		print('MLE estimator; \t' + str(estms[1]))
		print('\n')


def harmon_graphs():

	figs = []

	# For the following degrees of the harmonic based func., compute the estimation.
	for i in [6, 7, 8, 9, 10, 19]:
		figs.append(harmon_based_estimator(np.array(v['height']), np.array(v['weight']), i))

	show_figs(figs)


def harmon_nrmse():

	# For the following degrees of the polynomials, compute the nrmse.
	
	print('NRMSE: ')
	
	for i in [6, 7, 8, 9, 10, 19]:
		estms = harmon_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)
		print('Harmon feature function; degree: ' + str(i))
		print('MAP estimator; \t' + str(estms[0]))
		print('MLE estimator; \t' + str(estms[1]))
		print('\n')


def relu_graphs(which=[True, True, True, True, False]):

	figs = []

	# For the following degrees of the relu based func., compute the estimation.
	for i in [2, 5, 7, 8, 9]:
		figs.append(ReLu_based_estimator(np.array(v['height']), np.array(v['weight']), i, which))

	show_figs(figs)


def relu_nrmse():

	# For the following degrees of the relu based func., compute the nrmse.

	print('NRMSE: ')

	for i in [2, 5, 7, 10, 19]:
		estms = ReLu_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)
		print('ReLu feature function; degree: ' + str(i))
		print('MAP estimator; randn params; \t' + str(estms[0]))
		print('MAP estimator; linspace params; \t' + str(estms[1]))
		print('MAP lambda estimator; linspace params; \t' + str(estms[2]))
		print('MLE estimator; randn params; \t' + str(estms[3]))
		print('\n')

def comparative_nrmse():

	for i in [2, 5, 7, 10, 19]:
		estms_p_before = poly_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[0]
		estms_h_before = harmon_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[0]
		estms_r_before = ReLu_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[1]

		remove_outliers()

		estms_p = poly_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[0]
		estms_h = harmon_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[0]
		estms_r = ReLu_based_estimator_nrmse(np.array(v['height']), np.array(v['weight']), i)[1]

		revert_dataset()

		print('Comp. NRMSE MAP poly[d: ' + str(i) + '] improvement: ' + str(estms_p - estms_p_before))
		print('Comp. NRMSE MAP harmon[d: ' + str(i) + '] improvement: ' + str(estms_h - estms_h_before))
		print('Comp. NRMSE MAP relu[d: ' + str(i) + '] improvement: ' + str(estms_r - estms_r_before))
		print('\n')


def remove_outliers():
	global v

	vrnc = np.std(v['weight'])
	mm = np.mean(v['weight'])

	print("Mean: " + str(mm) + ", Variance: " + str(vrnc) + "\n")

	new_v = {
		'height': [],
		'weight': []
	}

	for i in range(len(v['weight'])):
		if v['weight'][i] < mm - vrnc or v['weight'][i] > mm + vrnc:
			continue
		else:
			new_v['height'].append(v['height'][i])
			new_v['weight'].append(v['weight'][i])

	v = new_v


def revert_dataset():
	global v

	v = {
    	'height': [148, 151, 150, 168, 160, 162, 188, 193, 141, 184, 192, 176, 183, 172, 178, 181, 181, 175, 194],
    	'weight': [61, 58, 64, 65, 55, 57, 100, 91, 46, 85, 112, 77, 83, 64, 100, 92, 86, 88, 88]
	}


def asgn_4c():
	plot_err(np.array(v['height']), np.array(v['weight']))


