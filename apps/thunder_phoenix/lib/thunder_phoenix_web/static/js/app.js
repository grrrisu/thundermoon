import "phoenix_html";
import "./phoenix";

if (document.getElementById("chat-input")) {
  import("./chat/chat_socket").then(function(page) {
    console.log("chat loaded");
  });
}

if (document.getElementById("reverse-input")) {
  import("./reverse/sim_basic_socket").then(function(page) {
    console.log("basic loaded");
  });
}

if (document.getElementById("counter")) {
  import("./counter/counter").then(function(page) {
    console.log("counter loaded");
  });
}

import "../css/app.scss";
