/* eslint-disable array-callback-return */
import {
  Box,
  Button,
  Modal,
  TextField,
  Typography,
  useTheme,
} from "@mui/material";
import { decodeToken } from "react-jwt";
import SeatAvailableNotSelected from "components/SeatAvailableNotSelected";
import SeatSelectedByMe from "components/SeatSelectedByMe";
import SeatSelectedNotByMe from "components/SeatSelectedNotByMe";
import SeatTemporary from "components/SeatTemporary";
import SeatUnavailable from "components/SeatUnavailable";
import React, { useEffect, useState } from "react";
import {
  Navigate,
  useNavigate,
  useParams,
  useSearchParams,
} from "react-router-dom";
import {
  useGetTripInfoQuery,
  useSelectSeatMutation,
  useUnselectSeatMutation,
  useReserveSeatMutation,
} from "state/api";
import { useSelector } from "react-redux";

const TripInfo = () => {
  const theme = useTheme();
  const [searchParams, setSearchParams] = useSearchParams();
  // console.log('checkshow',searchParams.get('show'))

  const navigate = useNavigate();
  const showValue = searchParams.get("show");
  const isJustShow = showValue === "1";
  if (showValue && searchParams.get("show") !== "1") {
    navigate("/");
  }
  const token = useSelector((state) => state.global.token);

  let decodedToken = null;
  if (token) {
    decodedToken = decodeToken(token) ?? null;
  }

  const isAll = Boolean(decodedToken?.roles?.includes("all"));
  const isCanReports = Boolean(decodedToken?.roles?.includes("reports"));
  const isCanControlTrips = Boolean(
    decodedToken?.roles?.includes("trips_control")
  );
  const isCanAddDriverAndAssistant = Boolean(
    decodedToken?.roles?.includes("add_drivers")
  );
  const isCanQuery = Boolean(decodedToken?.roles?.includes("query"));
  const styleModal = {
    position: "absolute",
    top: "50%",
    left: "50%",
    transform: "translate(-50%, -50%)",
    width: 600,
    bgcolor: "background.paper",
    border: "2px solid #000",
    // boxShadow: 24,
    p: 4,
  };
  const styleTextFields = {
    width: "100%",
    marginBottom: "20px",
    "& input": {
      color: theme.palette.primary[100], // Change the font color to red
      "&:focus": {
        borderColor: "blue", // Change the border color when focused
      },
    },
    "& label": {
      color: theme.palette.primary[100], // Change the label color to blue
    },
    "&:focus": {
      borderColor: theme.palette.primary[100], // Change the label color to blue
    },
    "& label.Mui-focused": {
      color: theme.palette.primary[100],
    },
    "& .MuiOutlinedInput-root": {
      "& fieldset": {
        borderColor: "grey",
      },
      "&:hover fieldset": {
        borderColor: theme.palette.primary[100],
      },
      "&.Mui-focused fieldset": {
        borderColor: theme.palette.primary[100],
      },
    },
  };
  const [
    selectSeat,
    { isLoading: mutationSelectIsLoading, isSuccess, isError, error },
  ] = useSelectSeatMutation();
  const [
    unselectSeat,
    {
      isLoading: mutationUnselectIsLoading,
      isUnselectSuccess,
      isUnselectError,
      unselectError,
    },
  ] = useUnselectSeatMutation();
  const [
    reserveSeats,
    {
      isLoading: mutationReserveSeatsIsLoading,
      isSuccess: isReserveSuccess,
      // isUnselectError,
      // unselectError
    },
  ] = useReserveSeatMutation();

  const [seatsForReservation, setSeatsForReservation] = useState([]);
  const [selectedSeat, setSelectedSeat] = React.useState(null);
  const [open, setOpen] = React.useState(false);
  const [openReservation, setOpenReservation] = React.useState(false);
  const [selectedIds, setSelectedIds] = useState([]);
  let newSeatsForReservations = [];
  const handleOpen = (element) => {
    setSelectedSeat(element);
    setOpen(true);
  };
  const handleConfirmReservationModal = () => {
    // setSelectedSeat(element);
    console.log("selectId", selectedIds);
    newSeatsForReservations = seats.filter((item) =>
      selectedIds.includes(item.id)
    );
    setSeatsForReservation(newSeatsForReservations);
    setOpenReservation(true);
  };
  const handleClose = () => setOpen(false);
  const handleConfirmClose = () => setOpenReservation(false);
  const { id } = useParams();
  const [seats, setSeats] = useState([]);
  const handleSeatClick = (seatId) => {
    setSeats((prevSeats) => {
      const index = prevSeats.findIndex((seat) => seat.number === seatId);
      const newSeats = [...prevSeats];
      newSeats[index] = {
        ...newSeats[index],
        is_selected: !newSeats[index].is_selected, // Toggle selection
        selected_by_me: true, // Assuming the user is the one selecting the seat
      };
      return newSeats;
    });
  };
  useEffect(() => {
    // Function to handle the SeatEvent
    const handleSeatEvent = (event) => {
      console.log("Real-time event received:", event);
      setSeats((prevSeats) => {
        const index = prevSeats.findIndex(
          (seat) => seat.number === event.seat_id
        );
        const newSeats = [...prevSeats];
        newSeats[index] = {
          ...newSeats[index],
          is_selected: event.seat_status === "selected" ? true : false,
          selected_by_me: event.source === "F" ? false : true,
        };
        return newSeats;
      });
    };

    // Subscribe to the channel and listen for the SeatEvent
    window.Echo.channel(`trip.${id}`).listen("SeatEvent", handleSeatEvent);

    // Cleanup when component unmounts
    return () => {
      window.Echo.leave(`trip.${id}`);
    };
  }, [id]);

  const { data, isLoading } = useGetTripInfoQuery(id);

  useEffect(() => {
    // When data is available, set it in the state
    if (!isLoading && data) {
      setSeats(data.data.trip.seats);
    }
  }, [isLoading, data]);

  const onConfirmClicked = async (e) => {
    await reserveSeats({ ids: selectedIds, full_name: fullName, phone: phone });

    // if (response.isSuccess) {
    //   setFullName('');
    //   handleConfirmClose();
    //   setSelectedIds([]);
    // }
  };

  useEffect(() => {
    // console.log('dssafkdjlkfj',isReserveSuccess);
    if (isReserveSuccess) {
      console.log("success");
      setFullName("");
      handleConfirmClose();
      setSelectedIds([]);
    }
  }, [isReserveSuccess]);

  const onSelectClicked = async (seat) => {
    // console.log('hh',seat);
    await selectSeat({ id: seat });
  };
  const onUnselectClicked = async (seat) => {
    // console.log('hh',seat);
    await unselectSeat({ id: seat });
  };
  const [fullName, setFullName] = useState("");
  const [phone, setPhone] = useState("");

  const firstVipBox = [
    1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26, 28, 29,
    31, 32,
  ];

  const firstNormalBox = [
    1, 2, 5, 6, 9, 10, 13, 14, 17, 18, 21, 22, 25, 26, 29, 30, 33, 34, 37, 38,
  ];
  const lastNormalBox = [41, 42, 43, 44, 45];

  const firstMiniBox = [1, 2, 5, 6, 9, 10, 13, 14, 17, 18, 21, 22, 25, 26];
  const secondMiniBox = [3, 7, 11, 15, 19, 23];

  const GetBoxContent = ({ children }) => {
    return (
      <Box
        bgcolor="#007b82"
        height="3rem"
        width="calc(100% - 2rem)"
        sx={{ borderRadius: "10px" }}
        display="flex"
        justifyContent="center"
        alignItems="center"
      >
        {children}
      </Box>
    );
  };

  console.log(data?.data);
  return !isLoading ? (
    <>
      <Modal
        open={open}
        onClose={handleClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
      >
        <Box sx={styleModal}>
          <Typography id="modal-modal-title" variant="h6" component="h2">
            Seat Information
          </Typography>
          {selectedSeat ? (
            <div>
              <p>Seat Number: {selectedSeat.number}</p>
              <p>Status: {selectedSeat.status}</p>
              {/* Add form elements here based on the selected seat */}
              <button onClick={handleClose}>Close</button>
            </div>
          ) : (
            <p>No seat selected.</p>
          )}
        </Box>
      </Modal>
      {/* modal for confirm reservation */}
      <Modal
        open={openReservation}
        onClose={handleConfirmClose}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
        sx={{
          textAlign: "right",
        }}
      >
        <Box sx={styleModal}>
          <Typography
            id="modal-modal-title"
            variant="h2"
            component="h2"
            textAlign="right"
            sx={{ textDecoration: "underline" }}
          >
            الدفع من خلال المركز
          </Typography>
          {seatsForReservation ? (
            <div>
              {seatsForReservation.map((item, index) => {
                if (index === seatsForReservation.length - 1) {
                  return "  " + item.number;
                } else {
                  return "  " + item.number + " ,";
                }
              })}
              <p
                style={{ display: "inline-block", fontSize: "16px" }}
                dir="rtl"
              >
                {" "}
                الرجاء ادخال الاسم ورقم الهاتف لحجز المقاعد الاتية : &nbsp;{" "}
              </p>
              <Typography
                id="modal-modal-title"
                variant="h5"
                component="h2"
                dir="rtl"
              >
                التكلفة الاجمالية{" "}
                <Typography variant="h2">
                  {" "}
                  {seatsForReservation.length * data.data.trip.ticket_price}
                </Typography>
              </Typography>
              <Box my="3rem" width="100%">
                <TextField
                  id="outlined-full_name-input"
                  label="Full Name"
                  type="text"
                  sx={styleTextFields}
                  value={fullName}
                  onChange={(e) => {
                    setFullName(e.target.value);
                  }}
                />

                <TextField
                  id="outlined-full_name-input"
                  label="Phone"
                  type="text"
                  sx={styleTextFields}
                  value={phone}
                  onChange={(e) => {
                    setPhone(e.target.value);
                  }}
                />
              </Box>
              <Button
                color="success"
                onClick={onConfirmClicked}
                disabled={
                  !mutationReserveSeatsIsLoading && fullName && phone
                    ? false
                    : true
                }
                sx={{ fontSize: "22px" }}
              >
                تأكيد
              </Button>
              <Button
                sx={{ fontSize: "22px" }}
                color="error"
                onClick={handleConfirmClose}
              >
                إلغاء
              </Button>
            </div>
          ) : (
            <p>No seat selected.</p>
          )}
        </Box>
      </Modal>
      <Box
        display="grid"
        // width="100%"
        m="3rem"
        gridTemplateColumns="repeat(3, 1fr)"
        gridAutoRows="100px"
        gap="2px"
      >
        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            الانطلاق : {data.data.trip.source_city.name}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            الوجهة : {data.data.trip.destination_city.name}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          {" "}
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            تاريخ الانطلاق :
            {new Date(data.data.trip.start_date).toLocaleString(undefined, {
              year: "numeric",
              month: "numeric",
              day: "numeric",
              hour: "numeric",
              minute: "numeric",
            })}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          {" "}
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            عدد المقاعد الكلية : {data.data.trip.number_of_seats}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            سعر التذكرة : {data.data.trip.ticket_price}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            عدد المقاعد المتبقية : {data.data.trip.seats_leaft}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            نوع الباص : {data.data.trip.bus.name}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            السائق: {data.data.trip.driver}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            مساعد السائق: {data.data.trip.assistant}
          </Typography>
        </GetBoxContent>

        <GetBoxContent>
          <Typography variant="h4" sx={{ color: theme.palette.secondary[50] }}>
            التقييم : {data.data.trip.rate}
          </Typography>
        </GetBoxContent>
      </Box>
      <Button
        onClick={() => navigate(`/trips/reservation/${id}`)}
        sx={{
          backgroundColor: theme.palette.secondary.light,
          // color: theme.palette.secondary.light,
          fontSize: "14px",
          fontWeight: "bold",
          padding: "10px 20px",
          mr: "2rem",
        }}
      >
        اظهار الحجوزات
      </Button>
      {(isAll || isCanControlTrips) && (
        <Button
          onClick={() => navigate(`/trips/edit/${id}`)}
          sx={{
            backgroundColor: theme.palette.secondary.light,
            // color: theme.palette.secondary.light,
            fontSize: "14px",
            fontWeight: "bold",
            padding: "10px 20px",
            mr: "2rem",
          }}
        >
          تعديل
        </Button>
      )}

      {selectedIds.length > 0 ? (
        <Box
          display="flex"
          justifyContent="center"
          mb="3rem"
          sx={{
            "&  .MuiButtonBase-root:hover": {
              // borderColor:"#ff0000" +"!important",
              color: theme.palette.primary[200],
              backgroundColor: theme.palette.secondary.light,
            },
          }}
        >
          <Button
            onClick={handleConfirmReservationModal}
            sx={{
              //  backgroundColor: theme.palette.secondary.light,
              // color: theme.palette.secondary.light,
              fontSize: "22px",
              fontWeight: "bold",
              padding: "10px 50px",
              color: "white",
              backgroundColor: "green",
            }}
          >
            تأكيد الحجز
          </Button>
        </Box>
      ) : (
        <Box display="flex" justifyContent="center" mb="5.8rem"></Box>
      )}
      <Box
        // display="grid"
        // width="100%"
        // mr="7.5rem"
        // //  m="3rem"
        // gridTemplateColumns="repeat(4, 1fr)"
        // gridAutoRows="100px"
        // gap="2px"
        flexWrap="wrap"
        display="flex"
        // flexDirection="row-reverse"
        width="100%"
        justifyContent="space-evenly"
        gap="4rem"
      >
        {data?.data?.trip?.bus?.number_seat === 33 ? (
          <>
            {/* first Box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              flexWrap="wrap"
              width="30%"
            >
              {seats.map((element, index) => {
                if (!firstVipBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                console.log(
                                  "🚀 ~ setSeats ~ newSeats:",
                                  newSeats
                                );
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                            console.log("🚀 ~ {seats.map ~ seats:", seats);
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          // onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
            {/* second box */}
            <Box>
              {seats.map((element, index) => {
                if (firstVipBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
          </>
        ) : null}
        {data?.data?.trip.bus?.number_seat === 45 ? (
          <>
            {/* first Box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              flexWrap="wrap"
              width="30%"
            >
              {seats.map((element, index) => {
                if (!firstNormalBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
            {/* second box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              flexWrap="wrap"
              width="30%"
            >
              {seats.map((element, index) => {
                if (
                  firstNormalBox.includes(element.number) ||
                  lastNormalBox.includes(element.number)
                )
                  return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
            {/* third box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="space-between"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              sx={{ transform: "translate(2.5rem,-3rem)" }}
              width="71%"
            >
              {seats.map((element, index) => {
                if (!lastNormalBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
          </>
        ) : null}
        {data?.data?.trip.bus?.number_seat === 27 ? (
          <>
            {/* first Box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              flexWrap="wrap"
              width="30%"
            >
              {seats.map((element, index) => {
                if (!firstMiniBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
            {/* second box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              flexWrap="wrap"
              width="30%"
              gap="3rem"
            >
              {/* third column */}
              <Box
                // display="flex"
                // // gridTemplateColumns="repeat(2, 1fr)"
                // justifyContent="flex-start"
                // alignItems="flex-start"
                // // flexDirection="row-reverse"
                // flexWrap="wrap"
                // width="30%"
                display="flex"
                flexDirection="column"
                gap="1rem"
                sx={{ transform: "translate(7rem,2rem)" }}
              >
                {seats.map((element, index) => {
                  if (!secondMiniBox.includes(element.number)) return null;
                  if (
                    element.status === "available" &&
                    element.is_selected === false
                  ) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => {
                              if (isJustShow) {
                              } else {
                                onSelectClicked(element.id);
                                let copySelectedInsert = [...selectedIds];
                                copySelectedInsert.push(element.id);
                                console.log("after insert", copySelectedInsert);
                                setSelectedIds(copySelectedInsert);
                                //  setSelectedIds(newSelectedIds);
                                setSeats((prevSeats) => {
                                  const newSeats = [...prevSeats];
                                  newSeats[index] = {
                                    ...newSeats[index],
                                    is_selected: true,
                                    selected_by_me: true,
                                  };
                                  return newSeats;
                                });

                                // console.log("heee");
                              }
                            }}
                          >
                            <SeatAvailableNotSelected
                              width={"80"}
                              height={"80"}
                            />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.status === "unavailable") {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatUnavailable width={"80"} height={"80"} />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.status === "temporary") {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatTemporary width={"80"} height={"80"} />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.is_selected && !element.selected_by_me) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatSelectedNotByMe width={"80"} height={"80"} />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.is_selected && element.selected_by_me) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => {
                              onUnselectClicked(element.id);

                              let index = selectedIds.indexOf(element.id);
                              if (index !== -1) {
                                let copySelected = [...selectedIds];
                                copySelected.splice(index, 1);
                                setSelectedIds(copySelected);
                                console.log(
                                  "selectedIds after deselect",
                                  copySelected
                                );
                              }
                              let seatIndex = seats.findIndex(
                                (seat) => seat.id === element.id
                              );
                              if (seatIndex !== -1) {
                                setSeats((prevSeats) => {
                                  const newSeats = [...prevSeats];
                                  newSeats[seatIndex] = {
                                    ...newSeats[seatIndex],
                                    is_selected: false,
                                    selected_by_me: false,
                                  };
                                  return newSeats;
                                });
                              }
                            }}
                          >
                            <SeatSelectedByMe width={"80"} height={"80"} />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  }
                })}
              </Box>
              {/* end third column */}
              {/* fourth column */}
              <Box
              // display="flex"
              // // gridTemplateColumns="repeat(2, 1fr)"
              // justifyContent="flex-start"
              // alignItems="flex-start"
              // // flexDirection="row-reverse"
              // flexWrap="wrap"
              // width="30%"
              >
                {seats.map((element, index) => {
                  if (
                    firstMiniBox.includes(element.number) ||
                    secondMiniBox.includes(element.number)
                  )
                    return null;
                  if (
                    element.status === "available" &&
                    element.is_selected === false
                  ) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => {
                              if (isJustShow) {
                              } else {
                                onSelectClicked(element.id);
                                let copySelectedInsert = [...selectedIds];
                                copySelectedInsert.push(element.id);
                                console.log("after insert", copySelectedInsert);
                                setSelectedIds(copySelectedInsert);
                                //  setSelectedIds(newSelectedIds);
                                setSeats((prevSeats) => {
                                  const newSeats = [...prevSeats];
                                  newSeats[index] = {
                                    ...newSeats[index],
                                    is_selected: true,
                                    selected_by_me: true,
                                  };
                                  return newSeats;
                                });

                                // console.log("heee");
                              }
                            }}
                          >
                            <SeatAvailableNotSelected />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.status === "unavailable") {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatUnavailable />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.status === "temporary") {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatTemporary />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.is_selected && !element.selected_by_me) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => handleOpen(element)}
                          >
                            <SeatSelectedNotByMe />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  } else if (element.is_selected && element.selected_by_me) {
                    return (
                      <Box width="50%" key={element.id}>
                        <div style={{ position: "relative" }}>
                          <Box
                            sx={{ cursor: "pointer" }}
                            onClick={() => {
                              onUnselectClicked(element.id);

                              let index = selectedIds.indexOf(element.id);
                              if (index !== -1) {
                                let copySelected = [...selectedIds];
                                copySelected.splice(index, 1);
                                setSelectedIds(copySelected);
                                console.log(
                                  "selectedIds after deselect",
                                  copySelected
                                );
                              }
                              let seatIndex = seats.findIndex(
                                (seat) => seat.id === element.id
                              );
                              if (seatIndex !== -1) {
                                setSeats((prevSeats) => {
                                  const newSeats = [...prevSeats];
                                  newSeats[seatIndex] = {
                                    ...newSeats[seatIndex],
                                    is_selected: false,
                                    selected_by_me: false,
                                  };
                                  return newSeats;
                                });
                              }
                            }}
                          >
                            <SeatSelectedByMe />
                          </Box>
                          <div
                            style={{
                              fontSize: "18px",
                              fontWeight: "bold",
                              position: "absolute",
                              top: "1rem",
                              right: "2.35rem",
                              color: "black",
                            }}
                          >
                            {element.number}
                          </div>
                        </div>
                      </Box>
                    );
                  }
                })}
              </Box>
              {/* end fourth column */}
            </Box>
            {/* third box */}
            {/* <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="space-between"
              alignItems="flex-start"
              // flexDirection="row-reverse"
              sx={{ transform: "translate(2.5rem,-3rem)" }}
              width="71%"
            >
              {seats.map((element, index) => {
                if (!lastNormalBox.includes(element.number)) return null;
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box> */}
          </>
        ) : null}
        {data?.data?.trip.bus?.number_seat !== 45 &&
        data?.data?.trip.bus?.number_seat !== 33 &&
        data?.data?.trip.bus?.number_seat !== 27 ? (
          <>
            {/* first Box */}
            <Box
              display="flex"
              // gridTemplateColumns="repeat(2, 1fr)"
              justifyContent="flex-start"
              alignItems="flex-start"
              flexDirection="row-reverse"
              flexWrap="wrap"
              width="100%"
            >
              {seats.map((element, index) => {
                if (
                  element.status === "available" &&
                  element.is_selected === false
                ) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            if (isJustShow) {
                            } else {
                              onSelectClicked(element.id);
                              let copySelectedInsert = [...selectedIds];
                              copySelectedInsert.push(element.id);
                              console.log("after insert", copySelectedInsert);
                              setSelectedIds(copySelectedInsert);
                              //  setSelectedIds(newSelectedIds);
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[index] = {
                                  ...newSeats[index],
                                  is_selected: true,
                                  selected_by_me: true,
                                };
                                return newSeats;
                              });

                              // console.log("heee");
                            }
                          }}
                        >
                          <SeatAvailableNotSelected />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "unavailable") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatUnavailable />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.status === "temporary") {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatTemporary />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && !element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => handleOpen(element)}
                        >
                          <SeatSelectedNotByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                } else if (element.is_selected && element.selected_by_me) {
                  return (
                    <Box width="50%" key={element.id}>
                      <div style={{ position: "relative" }}>
                        <Box
                          width="22%"
                          sx={{ cursor: "pointer" }}
                          onClick={() => {
                            onUnselectClicked(element.id);

                            let index = selectedIds.indexOf(element.id);
                            if (index !== -1) {
                              let copySelected = [...selectedIds];
                              copySelected.splice(index, 1);
                              setSelectedIds(copySelected);
                              console.log(
                                "selectedIds after deselect",
                                copySelected
                              );
                            }
                            let seatIndex = seats.findIndex(
                              (seat) => seat.id === element.id
                            );
                            if (seatIndex !== -1) {
                              setSeats((prevSeats) => {
                                const newSeats = [...prevSeats];
                                newSeats[seatIndex] = {
                                  ...newSeats[seatIndex],
                                  is_selected: false,
                                  selected_by_me: false,
                                };
                                return newSeats;
                              });
                            }
                          }}
                        >
                          <SeatSelectedByMe />
                        </Box>
                        <div
                          style={{
                            fontSize: "18px",
                            fontWeight: "bold",
                            position: "absolute",
                            top: "1rem",
                            right: "2.35rem",
                            color: "black",
                          }}
                        >
                          {element.number}
                        </div>
                      </div>
                    </Box>
                  );
                }
              })}
            </Box>
          </>
        ) : null}
      </Box>
    </>
  ) : (
    <div>loading .... !</div>
  );
};

export default TripInfo;
