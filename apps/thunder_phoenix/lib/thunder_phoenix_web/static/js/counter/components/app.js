import React from "react";
import { connect } from "react-redux";

import Counter from "./counter";
import SimButton from "./sim_button";

const mapStateToProps = state => {
  return {
    running: state.running
  };
};

const appComponent = ({ running }) => {
  return (
    <div className="counter-container">
      <Counter digit="100" />
      <Counter digit="10" />
      <Counter digit="1" />
      <SimButton running={running} />
    </div>
  );
};

module.exports = connect(mapStateToProps)(appComponent);
