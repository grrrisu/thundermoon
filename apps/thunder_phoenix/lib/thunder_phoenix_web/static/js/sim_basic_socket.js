import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });

socket.connect();

let channel = socket.channel("sim:basic", {});
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

channel
  .join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
  })
  .receive("error", resp => {
    console.log("Unable to join", resp);
  });

export default socket;
