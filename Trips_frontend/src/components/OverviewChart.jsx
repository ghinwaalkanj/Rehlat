import React, { useMemo } from "react";
import { ResponsiveLine } from "@nivo/line";
import { useTheme } from "@mui/material";
// import { useGetSalesQuery } from "state/api";

const OverviewChart = ({ isDashboard = false, view }) => {
  const theme = useTheme();
  const data = {
    totalCustomers: 5251,
    // yearlySalesTotal: 65152,
    yearlyTotalSoldUnits: 12969,
    year: 2021,
    monthlyData: [
      {
        month: "January",
        totalUnits: 17738,
        _id: "637000f7a5a686695b5170b1",
      },
      {
        month: "February",
        totalUnits: 50516,
        _id: "637000f7a5a686695b5170b2",
      },
      {
        month: "March",
        totalUnits: 8156,
        _id: "637000f7a5a686695b5170b3",
      },
      {
        month: "April",
        totalUnits: 11908,
        _id: "637000f7a5a686695b5170b4",
      },
      {
        month: "May",
        totalUnits: 2915,
        _id: "637000f7a5a686695b5170b5",
      },
      {
        month: "June",
        totalUnits: 24460,
        _id: "637000f7a5a686695b5170b6",
      },
      {
        month: "July",
        totalUnits: 22746,
        _id: "637000f7a5a686695b5170b7",
      },
      {
        month: "August",
        totalUnits: 41924,
        _id: "637000f7a5a686695b5170b8",
      },
      {
        month: "September",
        totalUnits: 75792,
        _id: "637000f7a5a686695b5170b9",
      },
      {
        month: "October",
        totalUnits: 689,
        _id: "637000f7a5a686695b5170ba",
      },
      {
        month: "November",
        totalUnits: 193,
        _id: "637000f7a5a686695b5170bb",
      },
      {
        month: "December",
        totalUnits: 14119,
        _id: "637000f7a5a686695b5170bc",
      },
    ],

  };

  const [ totalUnitsLine] = useMemo(() => {
    if (!data) return [];

    // console.log('before',data);
    const { monthlyData } = data;
    // console.log('after',monthlyData);
    // const totalSalesLine = {
    //   id: "totalSales",
    //   color: theme.palette.secondary.main,
    //   data: [],
    // };
    const totalUnitsLine = {
      id: "totalUnits",
      color: theme.palette.secondary[600],
      data: [],
    };

    // console.log("mon", monthlyData);
    Object.values(monthlyData).reduce(
      (acc, { month,  totalUnits }) => {
        // const curSales = acc.sales + totalSales;
        const curUnits = acc.units + totalUnits;

        // totalSalesLine.data = [
        //   ...totalSalesLine.data,
        //   { x: month, y: curSales },
        // ];
        totalUnitsLine.data = [
          ...totalUnitsLine.data,
          { x: month, y: curUnits },
        ];

        return { units: curUnits };
      },
      {  units: 0 }
    );

    return [ [totalUnitsLine]];
  }, [data]); // eslint-disable-line react-hooks/exhaustive-deps

  if (!data) return "Loading...";

  return (
    <ResponsiveLine
      data={ totalUnitsLine}
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
      margin={{ top: 20, right: 50, bottom: 50, left: 70 }}
      xScale={{ type: "point" }}
      yScale={{
        type: "linear",
        min: "auto",
        max: "auto",
        stacked: false,
        reverse: false,
      }}
      yFormat=" >-.2f"
      curve="catmullRom"
      enableArea={isDashboard}
      axisTop={null}
      axisRight={null}
      axisBottom={{
        format: (v) => {
          if (isDashboard) return v.slice(0, 3);
          return v;
        },
        orient: "bottom",
        tickSize: 5,
        tickPadding: 5,
        tickRotation: 0,
        legend: isDashboard ? "" : "Month",
        legendOffset: 36,
        legendPosition: "middle",
      }}
      axisLeft={{
        orient: "left",
        tickValues: 5,
        tickSize: 5,
        tickPadding: 5,
        tickRotation: 0,
        legend: isDashboard
          ? ""
          : `Total ${"Units"} for Year`,
        legendOffset: -60,
        legendPosition: "middle",
      }}
      enableGridX={false}
      enableGridY={false}
      pointSize={10}
      pointColor={{ theme: "background" }}
      pointBorderWidth={2}
      pointBorderColor={{ from: "serieColor" }}
      pointLabelYOffset={-12}
      useMesh={true}
      legends={
        !isDashboard
          ? [
              {
                anchor: "bottom-right",
                direction: "column",
                justify: false,
                translateX: 30,
                translateY: -40,
                itemsSpacing: 0,
                itemDirection: "left-to-right",
                itemWidth: 80,
                itemHeight: 20,
                itemOpacity: 0.75,
                symbolSize: 12,
                symbolShape: "circle",
                symbolBorderColor: "rgba(0, 0, 0, .5)",
                effects: [
                  {
                    on: "hover",
                    style: {
                      itemBackground: "rgba(0, 0, 0, .03)",
                      itemOpacity: 1,
                    },
                  },
                ],
              },
            ]
          : undefined
      }
    />
  );
};

export default OverviewChart;
