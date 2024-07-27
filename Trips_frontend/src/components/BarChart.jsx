import React from "react";
import { ResponsiveBar } from "@nivo/bar";
import { Box, useTheme } from "@mui/material";

const MyResponsiveBar = () => {
    const theme = useTheme();
  const data = [
    {
      country: "الحجوزات المؤقتة من التطبيق وتم تأكيدها من المركز",
      "الحجوزات المؤقتة من التطبيق وتم تأكيدها من المركز": 944,
      "hot dogColor": "hsl(307, 70%, 50%)",
    },
    {
        country: "الحجوزات المؤقتة من التطبيق وتم تأكيدها من التطبيق",
      "الحجوزات المؤقتة من التطبيق وتم تأكيدها من التطبيق": 250,
      burgerColor: "hsl(330, 70%, 50%)",
    },
    {
      country: "الحجوزات المؤكدة بشكل مباشر",
      "الحجوزات المؤكدة بشكل مباشر": 84,
      sandwichColor: "hsl(217, 70%, 50%)",
    },
  ];

  return (
    <ResponsiveBar
      data={data}
      theme={{
        fontSize: 16,
        // color: "white",
        textColor: theme.palette.secondary[50],
      }}
      keys={[ "الحجوزات المؤقتة من التطبيق وتم تأكيدها من المركز",  "الحجوزات المؤقتة من التطبيق وتم تأكيدها من التطبيق", "الحجوزات المؤكدة بشكل مباشر"]}
      indexBy="country"
      margin={{ top: 50, right: 12, bottom: 135, left: 2 }} // Adjust bottom margin to make space for legends
      padding={0.3}
      valueScale={{ type: "linear" }}
      indexScale={{ type: "band", round: true }}
      borderColor={{
        from: "color",
        modifiers: [["darker", 1.6]],
      }}
      axisTop={null}
      axisRight={null}
      //   axisBottom={{
      //     tickSize: 5,
      //     tickPadding: 0,
      //     tickRotation: 0,
      //     legend: "country",
      //     legendPosition: "start",
      //     legendOffset: 40, // Increase the offset to make space for legends
      //   }}
      axisBottom={null}
      //   axisLeft={{
      //     tickSize: 5,
      //     tickPadding: 5,
      //     tickRotation: 0,
      //     legend: "food",
      //     legendPosition: "middle",
      //     legendOffset: -40,
      //   }}
      axisLeft={null}
      labelSkipWidth={12}
      labelSkipHeight={12}
      labelTextColor={{
        from: "color",
        modifiers: [["darker", 1.6]],
      }}
      legends={[
        {
          dataFrom: "keys",
          anchor: "bottom-right",
          direction: "column", // Display legends in a row (horizontal)
          justify: true,
          translateX: 0,
          translateY: 140, // Adjust translateY to position the legends
          itemsSpacing: 0, // Adjust spacing between legend items
          itemWidth: 100,
          itemHeight: 40,
          itemDirection: "right-to-left",
          itemOpacity: 0.85,
          symbolSize: 20,
          effects: [
            {
              on: "hover",
              style: {
                itemOpacity: 1,
              },
            },
          ],
        //   itemTextColor: "white",
        },
      ]}
      role="application"
      ariaLabel="Nivo bar chart demo"
      barAriaLabel={(e) =>
        e.id + ": " + e.formattedValue + " in country: " + e.indexValue
      }
    />
  );
};

export default MyResponsiveBar;
