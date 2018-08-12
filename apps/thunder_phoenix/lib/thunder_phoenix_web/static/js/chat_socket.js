import socket from "./user_socket";

let channel = socket.channel("room:lobby", {});
let chatInput = document.querySelector("#chat-input");
let messagesContainer = document.querySelector("#messages");

chatInput.addEventListener("keypress", event => {
  if (event.keyCode === 13) {
    event.preventDefault();
    channel.push("new_msg", { body: chatInput.value });
    chatInput.value = "";
  }
});

channel.on("new_msg", payload => {
  let messageItem = document.createElement("li");
  let now = new Date().toLocaleDateString("de", {
    minute: "numeric",
    hour: "numeric",
    second: "numeric"
  });
  messageItem.innerText = `[${now}] ${payload.body}`;
  messagesContainer.appendChild(messageItem);
});

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });
