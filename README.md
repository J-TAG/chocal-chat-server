# chocal-chat-server

Chocal Chat is a cross platform application that can run in a local network.

This repository contains the server application that is needed to handle clients.

# Install

1. Chocal Chat server application is based on Qt Quick, so you need to install Qt development tools. It is tested on Fedora 23 but not on Mac or Windows. Although it should be run there without any problems.

2. Clone repository from github and open `ChocalServer.pro` in Qt Creator.

# Standards

## General type of a message that should be sent to server:

```javascript
{
    type: "",
    message: "",
    image: "",
    user_key: ""
}
```

`type` should be one of `plain`, `image` or `register`.
`message` is the message that user wants to send to others.
`image` is base64 encoded string of the image that user wants to send. This should have a value when using `type` of `image`, but in other cases it can be empty.
`user_key` is validation key of client to connect to server. This key will generate once user is first connected to server and will return back to client. In next messages client should provide this key.

## General type of message that server will send to clients:

```javascript
{
    type: "",
    name: "",
    message: "",
    image: "",
}
```

`type` should be one of `plain`, `image`, `info` or `error`.
`name` is sender client name.
`message` is the message that user wants to send to others.
`image` is base64 encoded string of the image that user wants to send. This will have a value when using `type` of `image`, but in other cases it will be empty.

## Message types:

Chocal Server will send four type of message to clients.

1. `accepted`
2. `plain`
3. `image`
4. `info`
5. `error`

`accepted` means client is successfuly connected to server and now can send messages.
`plain` means normal text message.
`image` means an image message.
`info` means an informative message that is not actually sent by a client and it is generated by server.
`error` means something went wrong and server is sent error details to client or clients.

On the other hand Chocal Server will expect these type of messages to recieve:

1. `register`
2. `plain`
3. `image`

`register` means that client wants to connect to chat.
`plain` means normal text message.
`image` means an image message.

## How to connect to server:

Clients can connect to server by sending below message to server:

```javascript
{
    type: "register",
    name: ""
}
```

If the `name` is taken currently the server will return an error message, otherwise it will be return a message of type `accepted` to client with a `user_key` property like this:

```javascript
{
    type: "accepted",
    name: "",
    message: "",
    user_key: ""
}
```

At this point, client is connected to server successfuly and now is able to send messages using its `user_key`.