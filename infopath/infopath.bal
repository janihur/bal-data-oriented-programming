# Description
#
# + data - Parameter Description  
# + informationPath - Parameter Description
# + return - Return Value Description
public function get1(map<json> data, string[] informationPath) returns json {
    map<json> current = data;
    foreach string pathItem in informationPath {
        json next = current[pathItem];

        if next !is map<json> {
            return next;
        }
        // cast is safe as the type can't be nothing but map<json>
        current = <map<json>> next; 
    }
    return current;
}

# Gets the value at path of data.
# This aims to be similar to https://lodash.com/docs/4.17.15#get
#
# + data - The data to query.
# + path - The path of the property to get.
# + return - The resolved value or null if no value found or if path is invalid
public function get2(map<json> data, (string|int)[] path) returns json {
    json current = data;
    foreach string|int pathItem in path {
        if pathItem is string && current is map<json> { // expecting json object
            current = (<map<json>>current)[pathItem];   
        } else if pathItem is int && current is json[] { // expecting json array
            current = (<json[]>current)[pathItem];
        } else { // invalid information path
            return ();
        }
    }
    return current;
}