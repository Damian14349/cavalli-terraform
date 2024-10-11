exports.handler = async function(event) {
    console.log("Hello, world!");
    return {
        statusCode: 200,
        body: JSON.stringify("Hello from Lambda!")
    };
};
