import socket from "../user_socket";

let channel = socket.channel("sim:counter", {});

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

exports.emit = (key, message) => {
  console.log(`send message ${message}`);
  channel.push(key, message);
};

exports.listen = (key, callback) => {
  channel.on(key, payload => {
    console.log(`received message ${key}: ${payload}`);
    callback(payload);
  });
};
