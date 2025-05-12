function downloadTodayExcel() {
  const table = document.getElementById("todayTable");
  const wb = XLSX.utils.table_to_book(table, { sheet: "오늘가입자" });
  XLSX.writeFile(wb, "today_customers.xlsx");
}
