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

######What about those weird operators?
Oh, I see! You are paying attention! Well, it's easy. Those operators do the *magic* trick. And there's a couple of them:

- `<>` allows you to extract any Foundation object (`String`, `Int`, `Float`, etc) from the JSON data to your specified property
- `<*>` allows you to extract any `JSONParsable` object from the JSON data to your specified property
- `<|*|>` allows you to extract an array of `JSONParsable` objects from the JSON data to your specified property
- `<|*|*|>` allows you to extract a dictionary of with `String`s as keys and `JSONParsable` objects as values from the JSON data to your specified property

Now using these operators should allow you to map any complicated data structure of your model.