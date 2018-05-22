import React from "react";


export default function Loading(props) {
  const { isLoading } = props;
  if (!isLoading) {
    return null;
  }
  return (
    <div className="loading_spinner_container">
        <img className="loading_spinner" src='../src/img/load_spinner.png' />
    </div>
  );
}
