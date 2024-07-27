import React from "react";

const SeatAvailableNotSelected = ({ width, height }) => {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width={`${width || "90"}`}
      height={`${height || "90"}`}
      viewBox="0 0 22 22"
      fill="none"
    >
      <path
        d="M6.1875 19.9375H3.4375C2.68125 19.9375 2.0625 19.3188 2.0625 18.5625V11.6875C2.0625 10.5187 2.95625 9.625 4.125 9.625C5.29375 9.625 6.1875 10.5187 6.1875 11.6875V19.9375Z"
        fill="white"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M18.5625 19.9375H15.8125V11.6875C15.8125 10.5187 16.7062 9.625 17.875 9.625C19.0438 9.625 19.9375 10.5187 19.9375 11.6875V18.5625C19.9375 19.3188 19.3187 19.9375 18.5625 19.9375Z"
        fill="white"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M15.8125 13.0625H6.1875V19.9375H15.8125V13.0625Z"
        fill="white"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M4.29297 9.65859V5.33372C4.29297 3.86884 5.43321 2.68298 6.84175 2.68298H15.0918C16.5674 2.68298 17.7076 3.86884 17.7076 5.33372V9.65859"
        fill="white"
      />
      <path
        d="M4.29297 9.65859V5.33372C4.29297 3.86884 5.43321 2.68298 6.84175 2.68298H15.0917C16.5674 2.68298 17.7076 3.86884 17.7076 5.33372V9.65859"
        stroke="#101010"
        strokeMiterlimit="10"
        strokeLinecap="round"
        strokeLinejoin="round"
      />
      <path
        d="M15.0476 12L6.95238 12V10.75L6.71429 9.74999L6 9H16L15.1717 10L15.0476 12Z"
        fill="white"
      />
    </svg>
  );
};

export default SeatAvailableNotSelected;
