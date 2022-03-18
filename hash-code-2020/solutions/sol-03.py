def main():
    """
    reading
    """
    with open("d_tough_choices.txt", "r") as f:
        lines = f.readlines()
        initial_data = lines[0].split(' ')
        B = int(initial_data[0])  # books, 10^5
        L = int(initial_data[1])  # libraries, 10^5
        D = int(initial_data[2])  # total time in days, 10^5
        book_scores = [int(val) for val in lines[1].split(' ')]  # book scores

        libraries = []
        _index = 2
        for i in range(L):
            library_initial_data = lines[_index].split(' ')
            book_ids = [int(val) for val in lines[_index + 1].split(' ')]
            N = int(library_initial_data[0])  # number of books
            T = int(library_initial_data[1])  # days to signup
            M = int(library_initial_data[2])  # books sending limit

            sum = 0
            for b in book_ids:
                sum += book_scores[b]
            libraries.append({'id': i, 'N': N, 'T': T, 'M': M, 'book_ids': book_ids, 'is_scanning': False, 'is_signing_up': False, 'sum': sum})
            _index += 2

    # print(str(B), str(L), str(D))
    # print(book_scores)

    algo1(B, L, D, book_scores, libraries)


def algo1(B, L, D, book_scores, libraries):
    scanned_book_ids = []
    libraries_used = []
    result = []
    libraries_done = []

    current_day = 0
    current_lib_index = 0

    """
    sort libraries by M/T  = sum of book scores / nr days for sign up (descending)
    """
    libraries = sorted(libraries, key=lambda k: k['sum'] / k['T'], reverse=True)
    # for l in libraries:
    #     print(str(l))

    """
    sort books inside each library based on score (descending)
    """
    for l in libraries:
        sorted_book_ids = sorted(l["book_ids"], key=lambda k: book_scores[k], reverse=True)
        l["book_ids"] = sorted_book_ids
    # for l in libraries:
    #     print(str(l))

    while current_day < D:
        # print("\n\t\t\t\t\tDAY " + str(current_day))
        if current_day == 0:
            lib = libraries[0]
            lib["is_signing_up"] = True
            lib["T"] -= 1
            # print("#### lib 0 signed up")
        else:
            signed_up_new_lib = False
            for lib in libraries:
                if lib["id"] in libraries_done:
                    continue
                if lib["is_signing_up"] is True and lib["T"] == 0:
                    """
                    done signing up
                    """
                    lib["T"] -= 1
                    lib["is_signing_up"] = False
                    lib["is_scanning"] = True
                    libraries_used.append(lib["id"])

                    """
                    start scanning
                    """
                    nr_books_to_scan_per_day = lib["M"]
                    nr_books_scanned = 0
                    books_scanned_by_this = []
                    for bid in lib["book_ids"]:
                        if nr_books_scanned >= nr_books_to_scan_per_day:
                            break
                        if bid not in scanned_book_ids:
                            scanned_book_ids.append(bid)
                            books_scanned_by_this.append(bid)
                            nr_books_scanned += 1

                            lib_already_in_res = False
                            for lres in result:
                                if lres["id"] == lib["id"]:
                                    lib_already_in_res = True
                                    lres["book_ids"].append(bid)
                                    break

                            if lib_already_in_res is False:
                                result.append({"id": lib["id"], "book_ids": [bid]})
                    for b in books_scanned_by_this:
                        lib["book_ids"].remove(b)
                    if len(lib["book_ids"]) == 0:
                        libraries_done.append(lib["id"])

                    # print("#### lib " + str(lib["id"]) + " done signing, starts scanning: " + str(books_scanned_by_this))
                elif lib["is_signing_up"] is True:
                    # print("#### lib " + str(lib["id"]) + " is signing, has " + str(lib["T"]) + " days left")
                    lib["T"] -= 1
                elif lib["is_signing_up"] is False and lib["is_scanning"] is False:
                    if libraries[current_lib_index]["is_signing_up"] == False and current_lib_index + 1 < len(libraries) and lib["id"] == libraries[current_lib_index + 1]["id"]:
                        lib["is_signing_up"] = True
                        lib["T"] -= 1
                        signed_up_new_lib = True
                        # print("#### lib " + str(lib["id"]) + " signed up ")

                elif lib["is_scanning"] is True:
                    nr_books_to_scan_per_day = lib["M"]
                    books_scanned_by_this = []
                    nr_books_scanned = 0
                    for bid in lib["book_ids"]:
                        if nr_books_scanned >= nr_books_to_scan_per_day:
                            break
                        if bid not in scanned_book_ids:
                            scanned_book_ids.append(bid)
                            books_scanned_by_this.append(bid)
                            nr_books_scanned += 1

                            lib_already_in_res = False
                            for lres in result:
                                if lres["id"] == lib["id"]:
                                    lib_already_in_res = True
                                    lres["book_ids"].append(bid)
                                    break

                            if lib_already_in_res is False:
                                result.append({"id": lib["id"], "book_ids": [bid]})

                    for b in books_scanned_by_this:
                        lib["book_ids"].remove(b)
                    if len(lib["book_ids"]) == 0:
                        libraries_done.append(lib["id"])
                    # print("#### lib " + str(lib["id"]) + " is scanning: " + str(books_scanned_by_this))

            if signed_up_new_lib is True:
                current_lib_index += 1
        current_day += 1

    """
    print results
    """
    # for l in libraries:
    #     print(str(l))

    # print(libraries_used)
    # print(scanned_book_ids)
    # for lib in result:
    #     print("id " + str(lib["id"]) + ", bids: " + str(lib["book_ids"]))

    f = open("output.txt", "w")
    f.write(str(len(libraries_used)) + "\n")
    for lib in result:
        f.write(str(lib["id"]) + " " + str(len(lib["book_ids"])) + "\n")
        for book_id in lib["book_ids"]:
            f.write(str(book_id) + " ")
        f.write("\n")
    f.close()


main()
