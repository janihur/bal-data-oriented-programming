import ballerina/io;

// {
//   "isbn": "978-1779501127",
//   "title": "Watchmen",
//   "publicationYear": 1987,
//   "authors": ["alan-moore", "dave-gibbons"],
//   "bookItems": [
//     {
//       "id": "book-item-1",
//       "libId": "nyc-central-lib",
//       "isLent": true
//     },
//     {
//       "id": "book-item-2",
//       "libId": "nyc-central-lib",
//       "isLent": false
//     }
//   ]
// }

// in the records below:
// {||} is a closed record
// readonly is required by table key

type Book1 record {|
    readonly string isbn;
    string title;
    int publicationYear;
    string[] authors;
    BookItem[] bookItems;
|};

type BookItem record {|
    readonly string id;
    string libId;
    boolean isLent;
|};

type Book2 record {| // for table
    readonly string isbn;
    string title;
    int publicationYear;
    string[] authors;
    string[] bookItemIds;
|};

public function main() {
    do {
        Book1 watchmen = {
            isbn: "978-1779501127",
            title: "Watchmen",
            publicationYear: 1987,
            authors: ["alan-moore", "dave-gibbons"],
            bookItems: [
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
            ]
        };

        io:println("----------");
        io:println("record type:");
        io:println(watchmen.toJsonString());
    }

    do {
        json watchmen = {
            isbn: "978-1779501127",
            title: "Watchmen",
            publicationYear: 1987,
            authors: ["alan-moore", "dave-gibbons"],
            bookItems: [
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
            ]
        };

        io:println("----------");
        io:println("json type:");
        io:println(watchmen.toJsonString());
    }

    do {
        table<Book2> key(isbn) books = table [
            {
                isbn: "978-1779501127",
                title: "Watchmen",
                publicationYear: 1987,
                authors: ["alan-moore", "dave-gibbons"],
                bookItemIds: ["book-item-1", "book-item-2"]
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

        Book2[] watchmen = from var book in books
            where book.title == "Watchmen"
            limit 1
            select book
        ;

        io:println("----------");
        io:println("table type");
        io:println(books);
        io:println(bookItems);
        io:println(watchmen[0].toJsonString());
    }
}