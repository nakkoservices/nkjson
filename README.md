**Update**: Added `NKJSON.rootKey` class variable used for accesing the whole underlaying JSON dictionary. See **Example 6** for details

---

#NKJSON
######The Swift class you were missing for those pesky JSON chunks of data

So, what's **NKJSON**? Well, it's a simple JSON class that let's you easily parse and map JSON data to your own model objects

######Where do you start?
Clone this repo here and import  **NKJSON.swift** file into your project. That's it! You're ready to use it!

######How do you do that?
Well, first of define your model objects. Remember! You can have any kind of properties you'd like. Even **Arrays** and or **Dictionaries** of your own objects

Once that's done just grab your JSON data from your server as you normally do and feed it to **NKJSON** class.

######Example
Imagine you have the following JSON data coming from your server:

    {
        "name": "Mickey",
        "id": {
        "series": "TC",
            "number": 123456
        }
    }

and you want to map it to your custom classes defined as bellow:

    class UserID {
        var series: String!
        var number: Int = 0
    }

    class User {
        var name: String!
        var id: UserID!
    }

Well, with **NKJSON** all you have to do is have your classes implement the `JSONParsable` protocol like this:

    class UserID: JSONParsable {
        var series: String!
        var number: Int = 0

        required init(JSON: NKJSON) {
            series <> JSON["series"]
            number <> JSON["number"]
        }
    }

    class User {
        var name: String!
        var id: UserID!

        required init(JSON: NKJSON) {
            name <> JSON["name"]
            id <*> JSON["id"] // See what this means bellow
        }
    }

After that's done just feed the JSON data to **NKJSON** and grab your `User` object in no time!

	let JSONData: NSData! // your JSON data goes here
	let user: User = NKJSON.parse(JSONData)

Easy, right? Told you!

######There's more!
Yup, there is more. You can have **NKJSON** parse an array of objects using the root of the JSON data or a specified key.

**Example 1:**

JSONData:

    [{
        "name": "Mickey",
        "id": {
            "series": "TC",
            "number": 123456
        }
    },
    {
        "name": "Andu",
        "id": {
            "series": "JI",
            "number": 789012
        }
    }]

Parsing it:

    let JSONData: NSData! // your JSON data hoes here
    let users: [User] = NKJSON.parse(JSONData)

**Example 2:**

JSONData:

    {"data": [
        {
            "name": "Mickey",
            "id": {
                "series": "TC",
                "number": 123456
            }
        },
        {
            "name": "Andu",
            "id": {
                "series": "JI",
                "number": 789012
            }
        }
    ]}

Parsing it:

    let JSONData: NSData! // your JSON data hoes here
    let users: [User] = NKJSON.parse(JSONData, key: "data")
    
**Example 3:**

JSONData:

	{
        "name": "Mickey",
        "id": {
            "series": "TC",
            "number": 123456
        },
        "country": {
        	"id": 123,
        	"name": "Romania"
        },
        "languages": [
        	{
        		"id": 123,
        		"name": "English"
        	},
        	{
        		"id": 456,
        		"name": "Romanian"
        	}
        ]
    }
    
    class User {
        var name: String!
        var countryName: String!
        var lastLanguageName: String!
        
        required init(JSON: NKJSON) {
            name <> JSON["name"]
            countryName <> JSON["country.name"] // Yup! You can even do that!
            lastLanguageName <> JSON["languages.1.name"] // Even that! Or any other combination for that matter
        }
    }

Parsing it:

    let JSONData: NSData! // your JSON data hoes here
    let user: User = NKJSON.parse(JSONData)

**Example 4:**

JSONData:

	{
        "name": "Mickey",
        "birthDay": "19.09.1988"
    }
        
    class User {
        var name: String!
        var birthDay: NSDate!
        
        func dateFormatter(object: AnyObject?) -> NSDate? {
        	if let dateString = object as? String {
            	let dateFormatter = NSDateFormatter()
	            dateFormatter.locale = NSLocale.systemLocale()
    	        dateFormatter.dateFormat = "dd.MM.yyyy"
        	    return dateFormatter.dateFromString(dateString)
	        }
	        return nil
    	}
        
        required init(JSON: NKJSON) {
            name <> JSON["name"]
            birthDay <> JSON["birthDay"] <<>> dateFormatter
        }
    }

Parsing it:

    let JSONData: NSData! // your JSON data hoes here
    let user: User = NKJSON.parse(JSONData)

**Example 5:**

JSONData:

	{
		"data": {
			"users": [
				{
					"name": "Mickey",
			        "birthDay": "19.09.1988"
				},
				{
					"name": "Andu",
			        "birthDay": "25.05.1986"
				}
			]
		}
    }
        
    class User {
        var name: String!
        var birthDay: NSDate!
        
        func dateFormatter(object: AnyObject?) -> NSDate? {
        	if let dateString = object as? String {
            	let dateFormatter = NSDateFormatter()
	            dateFormatter.locale = NSLocale.systemLocale()
    	        dateFormatter.dateFormat = "dd.MM.yyyy"
        	    return dateFormatter.dateFromString(dateString)
	        }
	        return nil
    	}
        
        required init(JSON: NKJSON) {
            name <> JSON["name"]
            birthDay <> JSON["birthDay"] <<>> dateFormatter
        }
    }

Parsing it:

    let JSONData: NSData! // your JSON data hoes here
    let mickey: User = NKJSON.parse(JSONData, key:"data.users.0")
    let andu: User = NKJSON.parse(JSONData, key:"data.users.1")
    let allUsers: [User] = NKJSON.parse(JSONData, key:"data.users")
    
**Example 6:**

Usually you initialize JSONParsable object using NKJSON.parse method. But maybe sometimes maybe all you want is a dictionary, or an array, or whatever else but NOT an `JSONParsable` object. Well take a look bellow to see how to do just that.

JSONData:

	{
		"data": {
			"users": [
				{
					"name": "Mickey",
			        "birthDay": "19.09.1988"
				}
			]
		}
    }

Parsing it:

	var dictioanry: [String: AnyObject]!
	if let JSON = NKJSON.parse(userString) {
	    var dictionary: [String: AnyObject]!
    	dictionary <> JSON[NKJSON.rootKey]
	}
	
######What about those weird operators?
Oh, I see! You are paying attention! Well, it's easy. Those operators do the *magic* trick. And there's a couple of them:

- `<>` allows you to extract any Foundation object (`String`, `Int`, `Float`, etc) from the JSON data to your specified property
- `<*>` allows you to extract any `JSONParsable` object from the JSON data to your specified property
- `<|*|>` allows you to extract an array of `JSONParsable` objects from the JSON data to your specified property
- `<|*|*|>` allows you to extract a dictionary of with `String`s as keys and `JSONParsable` objects as values from the JSON data to your specified property
- `<<>>` allows you to pass the JSON data through a data formatter before assigning it to your model's property. Very usefull for `NSDate` properties for example (see **Example 4**) or whenever you want to manipulate the data a bit more before assiging it

##Recap

So with **NKJSON** you can easily parse JSON and map it to your objects. All your have to do is follow these steps:

1. Have your model objects implement the `JSONParsable` protocol
2. Map your model's properties to JSON values using on of the above operator
3. Feed the JSON data to **NKJSON** and enjoy!

> Remember! You can use dot(`.`) notation for accesing child properties of JSON values as seen in **Example 3** and **Example 5**