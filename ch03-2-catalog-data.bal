import ballerina/io;

// var catalogData = {
//   "booksByIsbn": {
//     "978-1779501127": {
//       "isbn": "978-1779501127",
//       "title": "Watchmen",
//       "publicationYear": 1987,
//       "authorIds": ["alan-moore", "dave-gibbons"],
//       "bookItems": [
//         {
//           "id": "book-item-1",
//           "libId": "nyc-central-lib",
//           "isLent": true
//         },
//         {
//           "id": "book-item-2",
//           "libId": "nyc-central-lib",
//           "isLent": false
//         }
//       ]
//     }
//   },
//   "authorsById": {
//     "alan-moore": {
//       "name": "Alan Moore",
//       "bookIsbns": ["978-1779501127"]
//     },
//     "dave-gibbons": {
//       "name": "Dave Gibbons",
//       "bookIsbns": ["978-1779501127"]
//     }
//   }
// }

// json is union of:
// () | boolean | int | float | decimal | string | json[] | map<json>
//
// where json[]    is a json array
//   and map<json> is a json object

type Book record {|
    readonly string isbn;
    string title;
    int publicationYear;
    string[] authorIds;
    string[] bookItemIds;
|};

type Author record {|
    readonly string id;
    string name;
    string[] bookIsbns;
|};

type BookItem record {|
    readonly string id;
    string libId;
    boolean isLent;
|};

function get(map<json> data, string[] searchPath) returns json|error {
    map<json> current = data;
    foreach string item in searchPath {
        json next = current[item];

        if next !is map<json> {
            return next;
        }

        // never fails as the type can't be nothing but map<json>
        // so a cast should work too
        // current = <map<json>> next; 
        current = check next.ensureType();
    }
    return current;
}

public function main() returns error? {
    // json example
    do {
        map<json> catalogData = {
            "booksByIsbn": {
                "978-1779501127": {
                "isbn": "978-1779501127",
                "title": "Watchmen",
                "publicationYear": 1987,
                "authorIds": ["alan-moore", "dave-gibbons"],
                "bookItems": [
                    {
                    "id": "book-item-1",
                    "libId": "nyc-central-lib",
                    "isLent": true
                    },
                    {
                    "id": "book-item-2",
                    "libId": "nyc-central-lib",
                    "isLent": false
                    }
                ]
                }
            },
            "authorsById": {
                "alan-moore": {
                "name": "Alan Moore",
                "bookIsbns": ["978-1779501127"]
                },
                "dave-gibbons": {
                "name": "Dave Gibbons",
                "bookIsbns": ["978-1779501127"]
                }
            }
        };

        io:println("----------");
        io:println("json example");

        io:println(check get(catalogData, ["booksByIsbn", "978-1779501127", "title"]));
        io:println(check get(catalogData, ["booksByIsbn", "978-1779501127", "publicationYear"]));
        io:println(check get(catalogData, ["booksByIsbn", "978-1779501127", "authorIds"]));
        io:println(check get(catalogData, ["booksByIsbn", "978-1779501127"]));
    }

    // table example
    do {
        table<Book> key(isbn) books = table [
            {
                isbn: "978-1779501127",
                title: "Watchmen",
                publicationYear: 1987,
                authorIds: ["alan-moore", "dave-gibbons"],
                bookItemIds: ["book-item-1", "book-item-2"]
            }
        ];

        table<Author> key(id) authors = table [
            { 
                id: "alan-moore",
                name: "Alan Moore",
                bookIsbns: ["978-1779501127"]
            },
            {
                id: "dave-gibbons",
                name: "Dave Gibbons",
                bookIsbns: ["978-1779501127"]
            }
        ];

        table<BookItem> key(id) bookItems = table [
            {
                id: "book-item-1",
                libId: "nyc-central-lib",
                isLent: true
            },
            {
                id: "book-item-2",
                libId: "nyc-central-lib",
                isLent: false
            }
        ];

        io:println("----------");
        io:println("table example");

        do {
            [string, int][] result = from Book book in books
                where book.isbn == "978-1779501127"
                select [book.title, book.publicationYear];
            
            io:println(string`title: ${result[0][0]} publicationYear: ${result[0][1]}`);
        }

        do {
            json[] result = 
                from Author author in authors
                select {
                    name: author.name,
                    bookIsbns: author.bookIsbns
                }
            ;
            io:println(result);
        }

        do {
            json[] result = 
                from BookItem bookItem in bookItems
                where bookItem.libId == "nyc-central-lib" && !bookItem.isLent
                select bookItem
            ;
            io:println(result);
        }
    }
}