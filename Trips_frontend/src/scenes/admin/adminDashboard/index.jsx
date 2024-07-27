import React, { useEffect, useState } from "react";
import FlexBetween from "components/FlexBetween";
import Header from "components/Header";
import {
  DownloadOutlined,
  Email,
  PointOfSale,
  PersonAdd,
  Traffic,
} from "@mui/icons-material";
import {
  Box,
  Button,
  Typography,
  useTheme,
  useMediaQuery,
  Avatar,
  Select,
  MenuItem,
} from "@mui/material";
import { DataGrid } from "@mui/x-data-grid";
import BreakdownChart from "components/BreakdownChart";
import MyBarChart from "components/BarChart";
import OverviewChart from "components/OverviewChart";
import { useGetStats1ForAdminQuery, useGetStatsForAdminQuery } from "state/api";
import StatBox from "components/StatBox";
import { useTranslation } from "react-i18next";

const AdminDashboard = () => {
  const theme = useTheme();
  const isNonMediumScreens = useMediaQuery("(min-width: 1200px)");
  // const { data, isLoading } = useGetDashboardQuery();

  const { data: statsData, isLoading: isLoadingStats } =
    useGetStatsForAdminQuery();
  const { data: dashboardData2, isLoading: isDashboardLoading } =
    useGetStats1ForAdminQuery();
  const [dashboardData, setDashboardData] = useState({});
  const [selectValue, setSelectValue] = useState("day");
  useEffect(() => {
    setDashboardData(dashboardData2?.day);
  }, [isDashboardLoading]);
  const [t, i18n] = useTranslation();

  // const tableData = [
  //   {
  //     id: "1",
  //     source: "درعا",
  //     destination: "دمشق",
  //     // "start_date":"14:30",
  //     // "bus_type":"vip",
  //     prec: "90",
  //   },
  //   {
  //     id: "2",
  //     source: "دمشق",
  //     destination: "حمص",
  //     // "start_date":"14:30",
  //     // "bus_type":"vip",
  //     prec: "95",
  //   },
  //   {
  //     id: "3",
  //     source: "دمشق",
  //     destination: "حماه",
  //     // "start_date":"14:30",
  //     // "bus_type":"vip",
  //     prec: "79",
  //   },
  // ];

  // const columns = [
  //   // {
  //   //   field: "_id",
  //   //   headerName: "ID",
  //   //   flex: 1,
  //   // },
  //   {
  //     field: "source",
  //     headerName: t("from"),
  //     flex: 1,
  //   },
  //   {
  //     field: "destination",
  //     headerName: t("to"),
  //     flex: 1,
  //   },
  //   {
  //     field: "prec",
  //     headerName: "نسبة اكتمال الحجوزات",
  //     flex: 1,
  //     renderCell: (params) => (
  //       <Box
  //         textAlign="center"
  //         width="2rem"
  //         display="inline-block"
  //         sx={{
  //           backgroundColor: params.row.prec < 80 ? "red" : "green",
  //         }}
  //       >
  //         {params.row.prec}%
  //       </Box>
  //     ),
  //   },
  // ];

  const columnsCompany = [
    {
      field: "name_ar",
      headerName: "الاسم بالعربي",
      flex: 1,
    },
    {
      field: "name_en",
      headerName: "الاسم بالانكليزي",
      flex: 1,
    },
    {
      field: "username",
      headerName: "اسم المستخدم",
      flex: 1,
    },
    {
      field: "logo",
      headerName: "الشعار",
      flex: 1,
      renderCell: (params) => {
        return <Avatar alt="logo" src={params.row.logo} />;
      },
    },
  ];

  const columnsTrip = [
    {
      field: "source",
      headerName: "من",
      flex: 1,
    },
    {
      field: "destination",
      headerName: "إلى",
      flex: 1,
    },
    {
      field: "start_date",
      headerName: "موعد الرحلة",
      flex: 1,
    },
    {
      field: "bus",
      headerName: "نوع الباص",
      flex: 1,
    },
    {
      field: "rate",
      headerName: "تقييم",
      flex: 1,
    },
  ];

  const columnsMoneyReport = [
    {
      field: "day",
      headerName: "اليوم",
      flex: 1,
    },
    {
      field: "monyBackFromDeleteTrip",
      headerName: "المرتجع من الغاء الحجوزات",
      flex: 1,
    },
    {
      field: "totalFromAppReservation",
      headerName: "المدفوعات من حجز البرنامج  ",
      flex: 1,
    },

    {
      field: "reservationTemporaryAndReserverCenter",
      headerName: "المدفوعات من الحجز المؤقت والمثبت في مراكز الدفع",
      flex: 2,
    },
    {
      field: "reserveFromCenter",
      headerName: " المدفوعات من الحجوزات في مراكز الدفع",
      flex: 2,
    },
  ];

  return (
    <Box m="1.5rem 2.5rem">
      <FlexBetween>
        <Header title={t("dashboard")} subtitle={t("welcome")} />
      </FlexBetween>
      <Box width="30%" mx="auto">
        <Select
          fullWidth
          labelId="demo-simple-select-label"
          id="demo-simple-select"
          value={selectValue}
          label="Age"
          onChange={(e) => {
            setSelectValue(e.target.value);
            setDashboardData(dashboardData2[`${e.target.value}`]);
          }}
        >
          <MenuItem value={"day"}>يومي</MenuItem>
          <MenuItem value={"week"}>اسبوعي</MenuItem>
          <MenuItem value={"month"}>شهري</MenuItem>
        </Select>
      </Box>
      <Box
        mt="20px"
        display="grid"
        gridTemplateColumns="repeat(12, 1fr)"
        gridAutoRows="160px"
        gap="20px"
        sx={{
          "& > div": { gridColumn: isNonMediumScreens ? undefined : "span 12" },
        }}
      >
        {/* ROW 1 */}
        <Box gridColumn="span 6" gridRow="span 3">
          {/* <MyBarChart /> */}
          <Box display="flex" flexDirection="column" gap="3rem" mt="4rem">
            <Typography variant="h3">
              عدد الرحلات {dashboardData?.trip_counts}
            </Typography>
            <Typography variant="h3">
              {" "}
              عدد المقاعد في هذه الرحلات : {dashboardData?.count_seats}
            </Typography>
            <Typography variant="h3">
              عدد الحجوزات الكلية :{" "}
              {dashboardData?.count_confirmed_seat +
                dashboardData?.count_temporary_seat}
            </Typography>
            <Typography variant="h3">
              عدد الحجوزات المثبتة : {dashboardData?.count_confirmed_seat}
            </Typography>
            <Typography variant="h3">
              عدد الحجوزات المؤقتة : {dashboardData?.count_temporary_seat}
            </Typography>
            <Typography variant="h3">
              عدد المقاعد الفارغة : {dashboardData?.count_available_seats}
            </Typography>
            <Typography variant="h3">
              عدد المقاعد الملغاة : {dashboardData?.count_seats_canceled}
            </Typography>
          </Box>
        </Box>

        <Box
          gridColumn="span 6"
          gridRow="span 2"
          backgroundColor={theme.palette.background.alt}
          p="0rem"
          borderRadius="0.55rem"
          sx={{ transform: "translateY(6rem)" }}
        >
          {/* <Typography
            variant="h6"
            sx={{ color: theme.palette.secondary[50], textAlign: "left" }}
          >
            Earnings By Category
          </Typography> */}
          <BreakdownChart dashboardData={dashboardData} isDashboard={true} />
          <Typography
            p="0 0.6rem"
            fontSize="0.8rem"
            sx={{ color: theme.palette.secondary[200] }}
          ></Typography>
        </Box>
        <Box gridColumn="span 1" gridRow="span 3"></Box>

        {/* second section */}
        <Box
          gridColumn="span 6"
          gridRow="span 3"
          sx={{ transform: "translateY(8rem)" }}
        >
          {/* <MyBarChart /> */}
          <Box display="flex" flexDirection="column" gap="3rem" mt="4rem">
            <Typography variant="h3">
              {" "}
              قيمة الحجوزات الكلية : {dashboardData?.price_of_all_reservation}
            </Typography>
            <Typography variant="h3">
              قيمة الحجوزات المثبتة :{" "}
              {dashboardData?.price_of_confirmed_reservation}
            </Typography>
            <Typography variant="h3">
              قيمة الحجوزات المؤقتة :{" "}
              {dashboardData?.price_of_temporary_reservation}
            </Typography>
            <Typography variant="h3">
              قيمة الحجوزات الملغاة : {dashboardData?.value_of_seats_canceled}
            </Typography>
          </Box>
        </Box>

        <Box
          gridColumn="span 6"
          gridRow="span 2"
          backgroundColor={theme.palette.background.alt}
          p="0rem"
          borderRadius="0.55rem"
          sx={{ transform: "translateY(-18rem)" }}
        >
          {/* <Typography
            variant="h6"
            sx={{ color: theme.palette.secondary[50], textAlign: "left" }}
          >
            Earnings By Category
          </Typography> */}
          <BreakdownChart
            flag="section2"
            dashboardData={dashboardData}
            isDashboard={true}
          />
          <Typography
            p="0 0.6rem"
            fontSize="0.8rem"
            sx={{ color: theme.palette.secondary[200] }}
          ></Typography>
        </Box>
        {/* <Box gridColumn="span 1" gridRow="span 3"></Box> */}
        {/* end second section */}

        {/* third section */}
        <Box
          gridColumn="span 6"
          gridRow="span 3"
          sx={{ transform: "translateY(4rem)" }}
        >
          {/* <MyBarChart /> */}
          <Box display="flex" flexDirection="column" gap="3rem" mt="4rem">
            <Typography variant="h3">
              {" "}
              قيمة المدفوعات كاملة : {dashboardData?.all_payments}
            </Typography>
            <Typography variant="h3">
              قيمة المدفوعات عن طريق رحلات اون لاين:{" "}
              {dashboardData?.payment_via_app}
            </Typography>
            <Typography variant="h3">
              قيمة المدفوعات التي تمت حجزها عن طريق التطبيق وتم الدفع في مراكز
              الشركة : {dashboardData?.payment_from_app_and_office}
            </Typography>
            <Typography variant="h3">
              قيمة المدفوعات التي تم حجزها ودفعها عن طريق المركز :{" "}
              {dashboardData?.payment_from_office}
            </Typography>
          </Box>
        </Box>

        <Box
          gridColumn="span 6"
          gridRow="span 2"
          backgroundColor={theme.palette.background.alt}
          p="0rem"
          borderRadius="0.55rem"
          sx={{ transform: "translateY(-8rem)" }}
        >
          {/* <Typography
            variant="h6"
            sx={{ color: theme.palette.secondary[50], textAlign: "left" }}
          >
            Earnings By Category
          </Typography> */}
          <BreakdownChart
            flag="section3"
            dashboardData={dashboardData}
            isDashboard={true}
          />
          <Typography
            p="0 0.6rem"
            fontSize="0.8rem"
            sx={{ color: theme.palette.secondary[200] }}
          ></Typography>
        </Box>
        {/* <Box gridColumn="span 1" gridRow="span 3"></Box> */}
        {/* end third section */}

        <Box
          gridColumn="span 12"
          gridRow="span 3"
          sx={{
            "& .MuiDataGrid-root": {
              border: "none",
              borderRadius: "5rem",
            },
            "& .MuiDataGrid-cell": {
              borderBottom: `1px solid ${theme.palette.secondary[50]}`,
            },
            "& .MuiDataGrid-columnHeaders": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              borderBottom: "none",
              fontSize: "16px",
            },
            "& .MuiDataGrid-virtualScroller": {
              backgroundColor: theme.palette.background.alt,
            },
            "& .MuiDataGrid-footerContainer": {
              backgroundColor: theme.palette.background.alt,
              color: theme.palette.secondary[50],
              borderTop: "none",
            },
            "& .MuiDataGrid-toolbarContainer .MuiButton-text": {
              color: `${theme.palette.secondary[200]} !important`,
              fontSize: "16px",
            },
          }}
        >
          <Box textAlign="center">
            <Typography
              m="1rem 0.6rem"
              fontSize="2rem"
              sx={{ color: theme.palette.secondary[50] }}
            >
              القيود المالية{" "}
            </Typography>
          </Box>
          <DataGrid
            loading={isLoadingStats}
            getRowId={(row) => row.day}
            rows={statsData?.data?.result || []}
            columns={columnsMoneyReport}
          />
          <Box textAlign="center">
            <Typography
              m="1rem 0.6rem"
              fontSize="2rem"
              sx={{ color: theme.palette.secondary[50] }}
            >
              الشركات الحالية{" "}
            </Typography>
          </Box>
          <DataGrid
            loading={isLoadingStats}
            getRowId={(row) => row.id}
            rows={statsData?.data?.companies || []}
            columns={columnsCompany}
          />
          <Box textAlign="center">
            <Typography
              m="1rem 0.6rem"
              fontSize="2rem"
              sx={{ color: theme.palette.secondary[50] }}
            >
              الرحلات الأكثر طلباََ{" "}
            </Typography>
          </Box>
          <DataGrid
            loading={isLoadingStats}
            getRowId={(row) => row.id}
            rows={statsData?.data?.mostOrderedTrips || []}
            columns={columnsTrip}
          />
          <Box textAlign="center">
            <Typography
              m="1rem 0.6rem"
              fontSize="2rem"
              sx={{ color: theme.palette.secondary[50] }}
            >
              الرحلات الأقل طلباََ{" "}
            </Typography>
          </Box>
          <DataGrid
            loading={isLoadingStats}
            getRowId={(row) => row.id}
            rows={statsData?.data?.fewerOrderedTrips || []}
            columns={columnsTrip}
          />
        </Box>
      </Box>
    </Box>
  );
};

export default AdminDashboard;
