import ballerina/test;

final map<json> catalogData = {
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

final map<json> lodashExampleData = { a: [{ b: { c: 3 } }] };

function stringOnlyInformatioPathData() returns map<[map<json>, string[], json]>|error {
    return {
        "d01": [catalogData, ["booksByIsbn", "978-1779501127", "title"], 
            "Watchmen"],
        "d02": [catalogData, ["booksByIsbn", "978-1779501127", "publicationYear"],
            1987],
        "d03": [catalogData, ["booksByIsbn", "978-1779501127", "nonexisting"], 
            ()],
        "d04": [catalogData, ["nonexisting"], 
            ()],
        "d05": [catalogData, ["booksByIsbn", "978-1779501127", "authorIds"], 
            ["alan-moore", "dave-gibbons"]]
    };
}

function mixedInformationPathData() returns map<[map<json>, (string|int)[], json]>|error {
    return {
        "d01": [catalogData, ["booksByIsbn", "978-1779501127", "authorIds", 0], 
            "alan-moore"],
        "d02": [catalogData, ["booksByIsbn", "978-1779501127", "bookItems", 0, "isLent"], 
            true],
        "d03": [catalogData, ["booksByIsbn", 0], 
            ()],
        "d04": [catalogData, ["booksByIsbn", "978-1779501127", "authorIds", "nonexisting"], 
            ()],
        "lodash-1": [lodashExampleData, ["a", 0, "b", "c"], 
            3]
    };
}

@test:Config { dataProvider: stringOnlyInformatioPathData }
function get1Test1(map<json> data, string[] informationPath, json expectedValue) {
    test:assertEquals(get1(data, informationPath), expectedValue);
}

@test:Config { dataProvider: stringOnlyInformatioPathData }
function get2Test1(map<json> data, string[] informationPath, json expectedValue) {
    test:assertEquals(get2(data, informationPath), expectedValue);
}

@test:Config { dataProvider: mixedInformationPathData }
function get2Test2(map<json> data, (string|int)[] informationPath, json expectedValue) {
    test:assertEquals(get2(data, informationPath), expectedValue);
}
