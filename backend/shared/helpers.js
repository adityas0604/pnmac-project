const ONE_DAY_MS = 24 * 60 * 60 * 1000;

export const getLastNTradingDays = (n = 7) => {

    const tradingDates = [];

    let i = 1;

    while (tradingDates.length < n) {
        const date = new Intl.DateTimeFormat("en-US", {
            timeZone: "America/New_York",
            dateStyle: "full"
        }).format(new Date() - i * ONE_DAY_MS );

        const day = date.split(",")[0];

        if (day !== "Saturday" && day !== "Sunday") {
            const date = new Intl.DateTimeFormat("en-US", {
                timeZone: "America/New_York",
                year: "numeric",
                month: "2-digit",
                day: "2-digit",
            }).format(new Date() - i * ONE_DAY_MS );
              
            //CONVERT TO YYYY-MM-DD
            const dateArray = date.split("/")
            const dateString = dateArray[2] + "-" + dateArray[0] + "-" + dateArray[1];

            tradingDates.push(dateString);

        }
        i++;
    }
    return tradingDates;
}