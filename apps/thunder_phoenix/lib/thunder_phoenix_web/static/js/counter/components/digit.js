import React from "react";
import { connect } from "react-redux";

const mapStateToProps = (state, ownProps) => {
  const digitValue = state.digits[`digit_${ownProps.digit}`];
  return {
    digitValue: digitValue
  };
};

const digitComponent = ({ digitValue }) => {
  return (
    <div className="digit">
      <div className="badge badge-dark">{digitValue}</div>
    </div>
  );
};

module.exports = connect(mapStateToProps)(digitComponent);
