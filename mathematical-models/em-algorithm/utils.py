import numpy as np

def read_points(filename, sep):
	f = open(filename, 'r')
	lines = f.readlines()

	points = []
	for line in lines:
		line = line.strip(' \n')
		points.append(np.array([float(x) for x in line.split(sep)]))

	rows = len(points)
	cols = len(points[0])
	print('{} contains: {} lines, with {} {}s per line.'
		.format(filename, rows, cols, type(points[0][0]).__name__))

	return np.array(points), rows, cols

def init_w(n, k):
	row = [0] * n
	w = [np.array(row)] * k
	return w

def cov_mtrx(m):
	return np.diag([1 for _ in range(m)])

def convert_to_numpy_params(params):
	for key in params.keys():
		params[key] = np.array(params[key])
	return params

def zero_centroids(m, num_clusters):
	return [[0] * m] * num_clusters

def zero_covariance_matrices(m, num_clusters):
	return [cov_mtrx(m) for _ in range(num_clusters)]

def zero_probabilities(num_clusters):
	return [0] * num_clusters

def centroids_pretty_print(params):
	i = 0
	for row in ([[y for y in np.asarray(x[0])] for x in np.asarray(params['clusters centroids'])]):
		print(i, row)
		i += 1

def centroids_pretty(params):
	return [[y for y in np.asarray(x[0])] for x in np.asarray(params['clusters centroids'])]
