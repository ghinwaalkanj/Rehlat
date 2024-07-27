import {
  Box,
  Button,
  Dialog,
  DialogContent,
  Modal,
  Typography,
  useTheme,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import Header from "components/Header";
import React from "react";
import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useConfirmReservationMutation } from "state/api";

const ResultSearch = (props) => {
  console.log("props", props);
  // const { tripId } = useParams();
  const [selectedReservation, setSelectedReservation] = useState(null);
  const [openDialog, setOpenDialog] = useState(false);
  const theme = useTheme();
  // const data = props.searchData;
  const [data, setData] = useState(props.searchData);
  const [confirmReservation, { isSuccess, isLoading: isConfirmLoading }] =
    useConfirmReservationMutation();

  const onConfirmClicked = async (id) => {
    await confirmReservation(id);
    const updatedData = data.map((reservation) =>
      reservation.id === id
        ? {
            ...reservation,
            status: "unavailable",
            seats: reservation.seats.map((seat) => ({
              ...seat,
              status: "unavailable", // Assuming there's a 'status' field in seats
            })),
          }
        : reservation
    );

    // Update the state with the modified data
    setData(updatedData);
    handleCloseModal();
  };
  const navigate = useNavigate();
  const columns = [
    {
      field: "unique_id",
      headerName: "رقم الحجز",
      flex: 1,
    },
    {
      field: "user.name",
      headerName: "الاسم",
      flex: 1,
      valueGetter: (params) => params.row.seats[0].name,
    },
    {
      field: "user.phone",
      headerName: "رقم الهاتف",
      flex: 1,
      valueGetter: (params) =>
        params.row.user !== null ? params.row.user.phone : params.row.phone,
    },
    {
      field: "seats.length",
      headerName: "عدد المقاعد",
      flex: 1,
      valueGetter: (params) => params.row.seats.length,
    },
    {
      field: "seatNumbers",
      headerName: "ارقام المقاعد",
      flex: 1,
      renderCell: (params) => {
        const reservation = params.row;
        const seatNumbers = reservation.seats
          .map((seat) => seat.number_seat)
          .join(", ");

        const handleSeatClick = (reservationData) => {
          setSelectedReservation(reservationData);
          setOpenDialog(true);
        };

        return (
          <div>
            <button onClick={() => handleSeatClick(reservation)}>
              {seatNumbers}
            </button>
          </div>
        );
      },
    },

    {
      field: "reservationType",
      headerName: "نوع الحجز",
      flex: 2,
      // valueGetter: (params) => params.row.seats[0].status === "temporary" ? 'مؤقت' :'مؤكد'
      renderCell: (params) => (
        <div>
          <Box
            display="flex"
            gap="1.5rem"
            sx={{
              "& .MuiButton-outlined": {
                borderColor: theme.palette.secondary[300] + "!important",
                color: theme.palette.secondary[300],
              },
            }}
          >
            <Typography variant="h3">
              {params.row.seats[0].status === "temporary" ? "مؤقت" : "مؤكد"}
            </Typography>
            {params.row.seats[0].status === "temporary" && (
              <Button
                sx={{ marginLeft: "12px" }}
                disabled={isConfirmLoading ? true : false}
                onClick={() => {
                  setIdForReservation(params.row.id);
                  const reservation = params.row;
                  const seatNumbers = reservation.seats
                    .map((seat) => seat.number_seat)
                    .join(", ");
                  setSeatsData(seatNumbers);
                  setSelectedReservation(reservation);
                  setOpenModal(true);
                }}
                setSe
                variant="outlined"
              >
                تثبيت
              </Button>
            )}
          </Box>
        </div>
      ),
    },
    {
      field: "actions",
      headerName: "Actions",
      width: 180,
      renderCell: (params) => (
        <div>
          {/* {console.log('params',params)} */}
          <Box
            display="inline-block"
            sx={{
              "& .MuiButton-outlined": {
                borderColor: theme.palette.secondary[300] + "!important",
                color: theme.palette.secondary[300],
              },
            }}
          >
            <Button
              sx={{ marginRight: "18px" }}
              onClick={() => navigate(`/trips/${params.row.seats[0].trip_id}`)}
              variant="outlined"
            >
              إظهار
            </Button>
          </Box>

          {/* <Button variant="outlined" color="error">
            Delete
          </Button> */}
        </div>
      ),
    },
  ];
  const handleCloseDialog = () => {
    setOpenDialog(false);
  };
  const [idForReservation, setIdForReservation] = useState(null);
  const [seatsData, setSeatsData] = useState(null);
  const [openModal, setOpenModal] = useState(false);

  const handleCloseModal = () => {
    setOpenModal(false);
  };
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

  return (
    <Box m="1.5rem 2.5rem">
      <Modal
        open={openModal}
        onClose={handleCloseModal}
        aria-labelledby="modal-modal-title"
        aria-describedby="modal-modal-description"
        sx={{
          textAlign: "right",
        }}
      >
        <Box sx={styleModal}>
          <>
            <Typography
              id="modal-modal-title"
              variant="h2"
              component="h2"
              textAlign="right"
              sx={{ textDecoration: "none", mb: "2rem" }}
            >
              تثبيت الحجز المُنجز الكترونياََ
            </Typography>
            <Typography variant="h6">
              {console.log("reservation", selectedReservation)}
              {/* {selectedReservation?.user
                ? `User: + ${selectedReservation?.user?.name}`
                : "From Company"} */}
            </Typography>

            <div>
              <Typography sx={{ fontSize: "22px" }} variant="h6">
                عدد المقاعد : &nbsp;{selectedReservation?.seats?.length}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1">
                سعر التذكرة: {selectedReservation?.ticket_price}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1" dir="rtl">
                الاسم: {selectedReservation?.user?.name}
              </Typography>
              <Typography sx={{ fontSize: "22px" }} variant="body1">
                أرقام المقاعد: {seatsData}
              </Typography>
              <Typography sx={{ fontSize: "26px" }} variant="body1">
                السعر الاجمالي:{" "}
                {selectedReservation?.ticket_price *
                  selectedReservation?.seats?.length}
              </Typography>
              <hr />
              <Button
                color="success"
                onClick={() => onConfirmClicked(selectedReservation?.id)}
                sx={{ fontSize: "22px" }}
              >
                تأكيد
              </Button>
              <Button
                sx={{ fontSize: "22px" }}
                color="error"
                onClick={handleCloseModal}
              >
                إلغاء
              </Button>
            </div>
          </>
        </Box>
      </Modal>
      <Header title="الرحلات" subtitle="  الحجوزات الحالية" />
      <Box
        height="80vh"
        sx={{
          "& .MuiDataGrid-root": {
            border: "none",
            fontSize: "16px",
          },
          "& .MuiDataGrid-cell": {
            borderBottom: `1px solid ${theme.palette.secondary[50]}`,
            fontSize: "16px",
          },
          "& .MuiDataGrid-columnHeaders": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderBottom: "none",
            fontSize: "16px",
          },
          "& .MuiDataGrid-virtualScroller": {
            backgroundColor: theme.palette.primary.light,
            fontSize: "16px",
          },
          "& .MuiDataGrid-footerContainer": {
            backgroundColor: theme.palette.background.alt,
            color: theme.palette.secondary[50],
            borderTop: "none",
            fontSize: "16px",
          },
          "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
            color: `${theme.palette.secondary[200]} !important`,
            fontSize: "16px",
          },
        }}
      >
        <DataGrid
          loading={!data}
          getRowId={(row) => row.id}
          rows={(data && data) || []}
          columns={columns}
          rowCount={(data && data.length) || 0}
          rowsPerPageOptions={[20, 50, 100]}
        />
        <Dialog open={openDialog} onClose={handleCloseDialog}>
          <DialogContent>
            {selectedReservation && (
              <>
                <Typography variant="h6">
                  {selectedReservation?.user
                    ? `User: + ${selectedReservation?.user?.name}`
                    : "From Company"}
                </Typography>
                {selectedReservation.seats.map((seat, index) => (
                  <div key={index}>
                    <Typography variant="h6">Seat {index + 1}</Typography>
                    <Typography variant="body1">Name: {seat.name}</Typography>
                    <Typography variant="body1">
                      Seat Number: {seat.number_seat}
                    </Typography>
                    <hr />
                  </div>
                ))}
                <Button
                  onClick={handleCloseDialog}
                  variant="contained"
                  color="primary"
                >
                  Close
                </Button>
              </>
            )}
          </DialogContent>
        </Dialog>
      </Box>
    </Box>
  );
};

export default ResultSearch;
