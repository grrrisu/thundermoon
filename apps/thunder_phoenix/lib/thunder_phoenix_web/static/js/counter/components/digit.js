import React from "react";
import { connect } from "react-redux";

const mapStateToProps = state => {
  return {
    digit: state.digits.digit_1
  };
};

const digitComponent = ({ digit }) => {
  return (
    <div className="digit">
      <div className="badge badge-dark">{digit}</div>
    </div>
  );
};

module.exports = connect(mapStateToProps)(digitComponent);
