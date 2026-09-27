using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using ClosedXML.Excel;

namespace HonZi.Web.Services
{
    public class ExcelService : IExcelService
    {
        public async Task<ImportResultDto> ParseWordsFileAsync(Stream fileStream, string fileName)
        {
            var result = new ImportResultDto();
            var extension = Path.GetExtension(fileName).ToLowerInvariant();

            if (extension == ".csv")
            {
                using var reader = new StreamReader(fileStream, Encoding.UTF8);
                string? line;
                int rowNum = 0;
                while ((line = await reader.ReadLineAsync()) != null)
                {
                    rowNum++;
                    if (rowNum == 1 && (line.Contains("Hanzi") || line.Contains("Chữ Hán")))
                    {
                        continue; // Skip header
                    }
                    if (string.IsNullOrWhiteSpace(line)) continue;

                    var parts = line.Split(',');
                    if (parts.Length < 3)
                    {
                        result.FailureCount++;
                        result.Errors.Add($"Dòng {rowNum}: Thiếu các cột bắt buộc (Chữ Hán, Pinyin, Nghĩa tiếng Việt).");
                        continue;
                    }

                    var item = ParseItem(
                        parts[0].Trim(),
                        parts.Length > 1 ? parts[1].Trim() : "",
                        parts.Length > 2 ? parts[2].Trim() : "",
                        parts.Length > 3 ? parts[3].Trim() : "1",
                        parts.Length > 4 ? parts[4].Trim() : "Từ vựng chung",
                        parts.Length > 5 ? parts[5].Trim() : "",
                        parts.Length > 6 ? parts[6].Trim() : "",
                        rowNum
                    );

                    result.TotalRows++;
                    if (item.IsValid)
                    {
                        result.SuccessCount++;
                    }
                    else
                    {
                        result.FailureCount++;
                        result.Errors.Add($"Dòng {rowNum}: {item.ErrorMessage}");
                    }
                    result.ProcessedItems.Add(item);
                }
            }
            else // .xlsx
            {
                using var workbook = new XLWorkbook(fileStream);
                var worksheet = workbook.Worksheets.Count > 0 ? workbook.Worksheets.Worksheet(1) : null;
                if (worksheet == null)
                {
                    result.Errors.Add("File Excel không có trang tính (Worksheet) nào.");
                    return result;
                }

                int firstRow = 2; // Bỏ qua dòng tiêu đề
                int lastRow = worksheet.LastRowUsed()?.RowNumber() ?? 0;

                for (int r = firstRow; r <= lastRow; r++)
                {
                    var row = worksheet.Row(r);
                    if (row.IsEmpty()) continue;

                    string hanzi = row.Cell(1).GetString().Trim();
                    string pinyin = row.Cell(2).GetString().Trim();
                    string meaningVi = row.Cell(3).GetString().Trim();
                    string hskStr = row.Cell(4).GetString().Trim();
                    string topic = row.Cell(5).GetString().Trim();
                    string example = row.Cell(6).GetString().Trim();
                    string exampleMeaning = row.Cell(7).GetString().Trim();

                    if (string.IsNullOrEmpty(hanzi) && string.IsNullOrEmpty(meaningVi))
                        continue;

                    var item = ParseItem(hanzi, pinyin, meaningVi, hskStr, topic, example, exampleMeaning, r);

                    result.TotalRows++;
                    if (item.IsValid)
                    {
                        result.SuccessCount++;
                    }
                    else
                    {
                        result.FailureCount++;
                        result.Errors.Add($"Dòng {r}: {item.ErrorMessage}");
                    }
                    result.ProcessedItems.Add(item);
                }
            }

            return result;
        }

        private WordImportItem ParseItem(string hanzi, string pinyin, string meaningVi, string hskStr, string topic, string example, string exampleMeaning, int rowNum)
        {
            var item = new WordImportItem
            {
                Hanzi = hanzi,
                Pinyin = pinyin,
                MeaningVi = meaningVi,
                Topic = string.IsNullOrWhiteSpace(topic) ? "Từ vựng chung" : topic,
                ExampleSentence = example,
                ExampleMeaningVi = exampleMeaning
            };

            if (string.IsNullOrWhiteSpace(hanzi))
            {
                item.ErrorMessage = "Chữ Hán không được để trống.";
                return item;
            }

            if (string.IsNullOrWhiteSpace(pinyin))
            {
                item.ErrorMessage = "Pinyin không được để trống.";
                return item;
            }

            if (string.IsNullOrWhiteSpace(meaningVi))
            {
                item.ErrorMessage = "Nghĩa tiếng Việt không được để trống.";
                return item;
            }

            if (!int.TryParse(hskStr, out int hsk) || hsk < 1 || hsk > 6)
            {
                item.HskLevel = 1; // Default
            }
            else
            {
                item.HskLevel = hsk;
            }

            return item;
        }

        public byte[] GenerateSampleExcelTemplate()
        {
            using var workbook = new XLWorkbook();
            var ws = workbook.Worksheets.Add("Từ vựng mẫu");

            // Headers
            ws.Cell(1, 1).Value = "Chữ Hán (*)";
            ws.Cell(1, 2).Value = "Phiên âm Pinyin (*)";
            ws.Cell(1, 3).Value = "Nghĩa tiếng Việt (*)";
            ws.Cell(1, 4).Value = "Cấp độ HSK (1-6)";
            ws.Cell(1, 5).Value = "Chủ đề";
            ws.Cell(1, 6).Value = "Câu ví dụ";
            ws.Cell(1, 7).Value = "Dịch nghĩa câu ví dụ";

            var headerRow = ws.Row(1);
            headerRow.Style.Font.Bold = true;
            headerRow.Style.Fill.BackgroundColor = XLColor.FromHtml("#C23A22");
            headerRow.Style.Font.FontColor = XLColor.White;

            // Sample row
            ws.Cell(2, 1).Value = "你好";
            ws.Cell(2, 2).Value = "nǐ hǎo";
            ws.Cell(2, 3).Value = "Xin chào";
            ws.Cell(2, 4).Value = 1;
            ws.Cell(2, 5).Value = "Chào hỏi";
            ws.Cell(2, 6).Value = "你好！很高兴认识你。";
            ws.Cell(2, 7).Value = "Xin chào! Rất vui được quen biết bạn.";

            ws.Columns().AdjustToContents();

            using var ms = new MemoryStream();
            workbook.SaveAs(ms);
            return ms.ToArray();
        }
    }
}
