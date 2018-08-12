import socket from "./user_socket";

let channel = socket.channel("sim:basic", {});

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

// reverse text
let chatInput = document.querySelector("#reverse-input");
let reversedText = document.getElementById("reversed-text");

chatInput.addEventListener("keypress", event => {
  if (event.keyCode === 13) {
    event.preventDefault();
    reversedText.innerText = "... waiting ...";
    channel.push("reverse", { text: chatInput.value });
    chatInput.value = "";
  }
});

channel.on("reverse", payload => {
  let now = new Date().toLocaleDateString("de", {
    minute: "numeric",
    hour: "numeric",
    second: "numeric"
  });
  reversedText.innerText = payload.answer;
});

// crash event

let crashButton = document.getElementById("crash-button");

crashButton.addEventListener("click", event => {
  event.preventDefault();
  channel.push("crash", {});
});
