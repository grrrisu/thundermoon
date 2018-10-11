import ReactDOM from "react-dom";
import React from "react";
import { createStore } from "redux";
import { Provider } from "react-redux";

import Counter from "./components/counter";
import SimButton from "./components/sim_button";
import reducer from "./state/reducer";

let store = createStore(
  reducer,
  window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

ReactDOM.render(
  <Provider store={store}>
    <div className="counter-container">
      <Counter digit="100" />
      <Counter digit="10" />
      <Counter digit="1" />
      <SimButton />
    </div>
  </Provider>,
  document.getElementById("counter")
);
