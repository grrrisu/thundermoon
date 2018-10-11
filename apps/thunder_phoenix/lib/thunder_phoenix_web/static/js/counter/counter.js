import ReactDOM from "react-dom";
import React from "react";
import { createStore } from "redux";
import { Provider } from "react-redux";

import Counter from "./components/counter";
import SimButton from "./components/sim_button";
import reducer from "./state/reducer";

let store = createStore(reducer);

ReactDOM.render(
  <Provider store={store}>
    <div className="counter-container">
      <Counter />
      <Counter />
      <Counter />
      <SimButton />
    </div>
  </Provider>,
  document.getElementById("counter")
);
