import React from "react";
import { ResponsivePie } from "@nivo/pie";
import { Box, Typography, useTheme } from "@mui/material";
import { useGetSalesQuery } from "state/api";

const BreakdownChart = ({ isDashboard = false, dashboardData, flag }) => {
  // const { data, isLoading } = useGetSalesQuery();
  let data = {};
  if (flag === "section2") {
    data = {
      AllPrice: dashboardData?.price_of_all_reservation,
      FromTemporary: dashboardData?.price_of_temporary_reservation,
      FromConfirmed: dashboardData?.price_of_confirmed_reservation,
      FromCanceled: dashboardData?.value_of_seats_canceled,

      // misc: 19545,
    };
  } else if (flag === "section3") {
    data = {
      AllPayment: dashboardData?.all_payments,
      ViaApp: dashboardData?.payment_via_app,
      ViaAppAndOffice: dashboardData?.payment_from_app_and_office,
      ViaOffice: dashboardData?.payment_from_office,

      // misc: 19545,
    };
  } else {
    data = {
      // Trips: dashboardData?.trip_counts,
      // AllSeats: dashboardData?.count_seats,
      // AllReservations: dashboardData?.count_reservation,
      // ReservationConfirmed: dashboardData?.count_sticky_reservation,
      // ReservationTemporary: dashboardData?.count_temporary_reservation,
      AvailableSeats: dashboardData?.count_available_seats,
      ConfirmedSeats: dashboardData?.count_confirmed_seat,
      TemporarySeats: dashboardData?.count_temporary_seat,
      // misc: 19545,
    };
  }

  const theme = useTheme();

  // if (!data || isLoading) return "Loading...";

  const colors = [
    "#ef7838",
    "#ea8689",
    "#f4f4f4",
    theme.palette.secondary[600],
    // theme.palette.secondary[300],
    theme.palette.secondary[700],
    theme.palette.secondary[400],
    theme.palette.secondary[900],
    theme.palette.secondary[50],
  ];
  const total = Object.values(data).reduce((acc, curr) => acc + curr, 0);

  const formattedData = Object.entries(data).map(([category, sales], i) => ({
    id: category,
    label: category,
    value: sales,
    percentage: total === 0 ? 0 : ((sales / total) * 100).toFixed(2), // Calculate percentage
    color: colors[i],
  }));
  // const formattedData = Object.entries(data).map(([category, sales], i) => ({
  //   id: category,
  //   label: category,
  //   value: sales,
  //   color: colors[i],
  // }));

  return (
    <Box
      height={isDashboard ? "400px" : "100%"}
      width={undefined}
      minHeight={isDashboard ? "325px" : undefined}
      minWidth={isDashboard ? "325px" : undefined}
      position="relative"
    >
      <ResponsivePie
        data={formattedData}
        theme={{
          axis: {
            domain: {
              line: {
                stroke: theme.palette.secondary[200],
              },
            },
            legend: {
              text: {
                fill: theme.palette.secondary[200],
              },
            },
            ticks: {
              line: {
                stroke: theme.palette.secondary[200],
                strokeWidth: 1,
              },
              text: {
                fill: theme.palette.secondary[200],
              },
            },
          },
          legends: {
            text: {
              fill: theme.palette.secondary[200],
            },
          },
          tooltip: {
            container: {
              color: theme.palette.primary.main,
            },
          },
        }}
        colors={{ datum: "data.color" }}
        margin={
          isDashboard
            ? { top: 40, right: 80, bottom: 100, left: 50 }
            : { top: 40, right: 80, bottom: 80, left: 80 }
        }
        sortByValue={true}
        innerRadius={0.45}
        activeOuterRadiusOffset={8}
        borderWidth={1}
        borderColor={{
          from: "color",
          modifiers: [["darker", 0.2]],
        }}
        enableArcLinkLabels={!isDashboard}
        arcLinkLabelsTextColor={theme.palette.secondary[200]}
        arcLinkLabelsThickness={2}
        arcLinkLabelsColor={{ from: "color" }}
        arcLabels={(arc) => {
          console.log("eee", `${arc.data.label}: ${arc.data.percentage}`);
          return `${arc.data.label}: ${arc.data.percentage}%`;
        }}
        arcLabelsSkipAngle={10}
        arcLabelsTextColor={{
          from: "color",
          modifiers: [["darker", 2]],
        }}
        // legends={[
        //   {
        //     anchor: "bottom",
        //     direction: "row",
        //     justify: false,
        //     translateX: isDashboard ? 20 : 0,
        //     translateY: isDashboard ? 50 : 56,
        //     itemsSpacing: 10, // Adjust spacing between items
        //     itemWidth: 100, // Set the width of each legend item
        //     // itemsSpacing: 0,
        //     // itemWidth: 85,
        //     itemHeight: 18,
        //     itemTextColor: "#999",
        //     itemDirection: "left-to-right",
        //     itemOpacity: 1,
        //     symbolSize: 18,
        //     symbolShape: "circle",
        //     effects: [
        //       {
        //         on: "hover",
        //         style: {
        //           itemTextColor: theme.palette.primary[500],
        //         },
        //       },
        //     ],
        //   },
        // ]}
      />
      <Box
        position="absolute"
        top="50%"
        left="50%"
        color={theme.palette.secondary[400]}
        textAlign="center"
        pointerEvents="none"
        sx={{
          transform: isDashboard
            ? "translate(-75%, -170%)"
            : "translate(-50%, -100%)",
        }}
      >
        <Typography variant="h6">
          {/* {!isDashboard && "Total:"} ${data.yearlySalesTotal} */}
        </Typography>
      </Box>
    </Box>
  );
};

export default BreakdownChart;
