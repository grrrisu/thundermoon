import ReactDOM from "react-dom";
import React from "react";
import { createStore } from "redux";
import { Provider } from "react-redux";

import Counter from "./components/counter";
import reducer from "./state/reducer";

let store = createStore(reducer);

ReactDOM.render(
  <Provider store={store}>
    <Counter />
  </Provider>,
  document.getElementById("counter")
);
