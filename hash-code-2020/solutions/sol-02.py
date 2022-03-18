import math

with open("f_libraries_of_the_world.txt", "r") as f:
    lines = f.readlines()
    initial_data = lines[0].split(' ')
    B = int(initial_data[0]) # books, 10^5
    L = int(initial_data[1]) # libraries, 10^5
    D = int(initial_data[2]) # total time in days, 10^5
    book_scores = [int(val) for val in lines[1].split(' ')] # book scores

    libraries = []
    _index = 2
    for i in range(L):
        library_initial_data = lines[_index].split(' ')
        book_ids = [{'id': int(val), 'score': book_scores[int(val)]} for val in lines[_index + 1].split(' ')]
        N = int(library_initial_data[0]) # number of books
        T = int(library_initial_data[1]) # days to signup
        M = int(library_initial_data[2]) # books sending limit
        libraries.append({'id': i, 'N': N, 'T': T, 'M': M, 'book_ids': book_ids, 'weight': 0})
        _index += 2

# print('B: ', str(B), ', L: ', str(L), ', D: ', str(D))
# print(book_scores)

already_scanned_book_ids = [] # for many duplicates

for l in libraries:
    # deduplicate ids ---- no need
    # eliminim ce e deja scanat
    bkids = [book['id'] for book in l['book_ids']]
    aux = set(bkids) - set(already_scanned_book_ids)
    aux2 = [{'id': val, 'score': book_scores[val]} for val in aux]
    l['book_ids'] = aux2
    # actualizez numarul de carti ale librariei
    l['N'] = len(l['book_ids'])
    l['book_ids'].sort(key=lambda x:x['score'], reverse=True) # for diff scores
    already_scanned_book_ids += aux
    total = 0
    for book in l['book_ids']:
        total += book['score']
    l['weight'] = total/l['T']
    
libraries.sort(key=lambda x:x['weight'], reverse=True)

current_start_day = 0
days_left = D
index = 0
no_libraries = L
out_libraries = []

while index < len(libraries) and days_left - libraries[index]['T'] > 0:
    if libraries[index]['N'] > 0:
        # print(libraries[index])
        current_start_day += libraries[index]['T']
        # print('start: ', current_start_day)
        days_left -= libraries[index]['T']
        # print('left: ', days_left)
        days = min(days_left + 1, math.ceil(libraries[index]['N']/libraries[index]['M']))
        throughput = days * libraries[index]['M']
        throughput = min(throughput, libraries[index]['N'])
        # print('days: ', days)
        # print('th: ', throughput)
        out_libraries.append({'id': libraries[index]['id'], 'no_books': throughput, 'book_ids': libraries[index]['book_ids'][:throughput]})
        no_libraries -= 1
    index += 1
    # print()

with open("output.txt", "w+") as f:
    f.write(str(len(out_libraries)))
    f.write("\n")
    for l in out_libraries:
        f.write(str(l['id']))
        f.write(' ')
        f.write(str(l['no_books']))
        f.write('\n')
        for book_id in l['book_ids']:
            f.write(str(book_id['id']))
            f.write(' ')
        f.write('\n')
