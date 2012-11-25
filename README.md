Temporary Rails API
===================
###[ Staged on Heroku ]( secretrevelations.herokuapp.com )

Getting Mods
------------
_Note: This API will respond to HTTP methods other than GET but is intended only for use with GET and will only retrieve resources, not create or modify them_
Currently the root route returns all mods. This data is encoded in JSON, if the response to any request is a single record, that objec is returned, if it is more than one record the response is an array.

Schema
------
Currently a mod has the following schema:

    _______________________________
    | FIELD             | TYPE    |
    |-------------------|---------|
    | id                | integer |
    | name              | varchar |
    | author            | varchar |
    | minecraft_version | varchar |
    | forum_url         | varchar |
    L-----------------------------/

Routes
------
_A "route" is the part of the URL that follows the hostname; i.e. the hostname is [ secretrevelations.herokuapp.com ]( secretrevelations.herokuapp.com ), `secretrevelations.herokuapp.com/mods` has a route of `/mods`_

####Tags
_Anywhere there is a `<arbitrary text here>`, it will hence be referred to as a tag; all tags in this documentation are designed to serve as placeholders for some variable input_

###All Mods
*WARNING:* there are currently upwards of 14,000 records in the DB. If you're running low on memory I don't recommend pointing your browser to this resource as they will be returned as text in your browser

`/mods`

###Single Mod by ID
`/mods/<id>`

Searching for Mods
------------------
_All searches are currently performed using an SQL where clause like this: `WHERE <field> like '%<query>%'`
_The use of periods and spaces is permitted in all searches_

###By Name
`/mods/name/<name to search for>`

###By Minecraft Version
`/mods/version/<version to search for>`

###By Author Handle
_Author handles are those of the [ curse ]( http://www.curse.com/ ) user who posted the minecraft forum topic that the mod originated from_
`/mods/author/<author to search for>`
