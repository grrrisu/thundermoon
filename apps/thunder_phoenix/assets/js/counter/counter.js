import ReactDOM from "react-dom";
import React from "react";
import { createStore } from "redux";
import { Provider } from "react-redux";

import App from "./components/app";
import reducer from "./state/reducer";
import { listen } from "./websocket";

let store = createStore(
  reducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

listen("change", payload => {
  store.dispatch({ type: "CHANGE", payload: payload });
});

listen("joined", payload => {
  store.dispatch({ type: "JOINED", payload: payload });
});

listen("started", payload => {
  store.dispatch({ type: "SIM_STARTED", payload: payload });
});

listen("stopped", payload => {
  store.dispatch({ type: "SIM_STOPPED", payload: payload });
});

ReactDOM.render(
  <Provider store={store}>
    <App />
  </Provider>,
  document.getElementById("counter")
);
