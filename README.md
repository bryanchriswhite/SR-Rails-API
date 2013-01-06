Secret Revelations API (work in progress)
===================
###[ Staged at wiglepedia.org ]( wiglepedia.org )

####Tags
_Anywhere there is a `<arbitrary text here>`, it will hence be referred to as a tag; all tags in this documentation are designed to serve as placeholders for some variable input_

####Optional
_Anywhere there is a `[arbitrary text here]`, it should be considered optional._

####Routes
_A "route" is the part of the URL that follows the hostname; i.e. the hostname is [ wiglepedia.org ]( wiglepedia.org ), `wiglepedia.org/mods` has a route of `/mods`_

Authentication
--------------
The API uses [ HTTP Digest Authentication ]( http://en.wikipedia.org/wiki/Http_digest_authentication ) for authorizing user-agents. If a user-agent attempts to access a protected resource it will receive an HTTP 401 challenge response with the `WWW_Authorize` header set; therefore, authentication may take place at any time, on any resource. If the user-agent has already successfully authenticated it may access any protected resource (for the respective credentials) by simply setting the `Authorize` header in the request.

_NOTE: the `status` key/property in the JSON response for authentications is designed to reflect the meaning of the respective HTTP status code, i.e.: 200 = Success/OK, 400 = Bad Request, 201 = Created, etc._

###Signing In
If you simply want to authenticate with the API to set your `Authorize` request header, request the `/users` resource with the GET HTTP method.

####Response
If the request was successful the response will be a JSON object whose structure is:
`{status: 200, message: 'successfully authenticated', user: {username: <username>, email: <email>, password_hash: <password hash>} }

If unsuccessful the response will be a 401 Unauthorized with HTML body saying 'HTTP Digest: Access denied.'

_NOTE: this soon to be replaced with an HTTP 200 response with a JSON body containing something like `{status: 401, message: <reason you couldn't be authenticated>}`_

###Registering
To register a user account with the api submit a request to the `/users` resource with the HTTP POST method. The POST data should look like the following:
`user[email]=<email address>&user[password_hash]=<md5 hex digest of "<username>:<realm>:<plain text password>">&user[username]=<username>`

#####Validation Restrictions
The API will consider any request whose email and/or username are already in use invalid. The request must contain email, username and password (nothing more).

#####Example Using Curl:
`curl -vd "user%5Bemail%5D=test@example.com%40gmail.com&user%5Bpassword_hash%5D=0101713f36fc52cd5a51dd03f43a7e98&user%5Busername%5D=tester" http://localhost:3001/v1/users`


Getting Resources
------------
Currently the root route returns all mods. This data is encoded in JSON, if the response to any request is a single record, that objec is returned, if it is more than one record the response is an array.

Schema
======

Mods
----
Currently a mod has the following schema:

| Field             | Type    |
|-------------------|---------|
| id                | integer |
| name              | varchar |
| author            | varchar |
| minecraft_version | varchar |
| forum_url         | varchar |

Categories
----------
Categories have the following schema:

| Field             | Type    |
|-------------------|---------|
| name              | string  |

Mods
----

###All Mods
*WARNING:* there are currently upwards of 14,000 records in the DB. If you're running low on memory I don't recommend pointing your browser to this resource as they will be returned as text in your browser

`/mods`

###Single Mod by ID
`/mods/<id>`

###Range of Mods
_Note: `[]` (square brackets) indicate optional parameters_
`/mods/count/<number of mods to get>/[offset/<number of mods to skip before beginning of range>]`

Searching for Mods
------------------
_All searches are currently performed using an SQL where clause like this: `WHERE <field> like '%<query>%'`_
_The use of periods and spaces is permitted in all searches_

###By Name
`/mods/name/<name to search for>`

###By Minecraft Version
`/mods/version/<version to search for>`

###By Author Handle
_Author handles are those of the [ curse ]( http://www.curse.com/ ) user who posted the minecraft forum topic that the mod originated from_
`/mods/author/<author to search for>`

###How Many Mods?
_Returns an integer that is the total number of mods in the DB currently_
`/mods/total`

Categories
----------

###All Categories
`/categories`
