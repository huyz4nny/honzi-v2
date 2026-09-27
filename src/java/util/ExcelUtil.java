package util;

import model.Word;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

public class ExcelUtil {

    /**
     * Phân tích tệp Excel (.xlsx hoặc .csv) và trả về danh sách Word
     */
    public static List<Word> parseFile(InputStream is, String fileName) throws Exception {
        if (fileName == null) {
            return new ArrayList<>();
        }
        String lower = fileName.toLowerCase();
        if (lower.endsWith(".xlsx")) {
            return parseXlsx(is);
        } else {
            // Mặc định xử lý như CSV / Text
            return parseCsv(is);
        }
    }

    /**
     * Đọc tệp Excel (.xlsx) chuẩn OpenXML bằng bộ giải nén và XML Parser tích hợp sẵn trong Java
     */
    public static List<Word> parseXlsx(InputStream is) throws Exception {
        byte[] sharedStringsXml = null;
        byte[] sheet1Xml = null;

        // Đọc toàn bộ ZIP archive
        try (ZipInputStream zis = new ZipInputStream(is)) {
            ZipEntry entry;
            while ((entry = zis.getNextEntry()) != null) {
                String name = entry.getName();
                if (name.equals("xl/sharedStrings.xml")) {
                    sharedStringsXml = readBytes(zis);
                } else if (name.equals("xl/worksheets/sheet1.xml")) {
                    sheet1Xml = readBytes(zis);
                }
                zis.closeEntry();
            }
        }

        if (sheet1Xml == null) {
            throw new Exception("Không tìm thấy sheet dữ liệu (sheet1.xml) trong file Excel!");
        }

        // 1. Phân tích Shared Strings Table (nếu có)
        List<String> sharedStrings = new ArrayList<>();
        if (sharedStringsXml != null) {
            DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
            DocumentBuilder db = dbf.newDocumentBuilder();
            Document doc = db.parse(new ByteArrayInputStream(sharedStringsXml));
            NodeList siNodes = doc.getElementsByTagName("si");
            for (int i = 0; i < siNodes.getLength(); i++) {
                Element si = (Element) siNodes.item(i);
                NodeList tNodes = si.getElementsByTagName("t");
                StringBuilder sb = new StringBuilder();
                for (int j = 0; j < tNodes.getLength(); j++) {
                    sb.append(tNodes.item(j).getTextContent());
                }
                sharedStrings.add(sb.toString().trim());
            }
        }

        // 2. Phân tích Sheet1 Data
        List<List<String>> rawRows = new ArrayList<>();
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = dbf.newDocumentBuilder();
        Document sheetDoc = db.parse(new ByteArrayInputStream(sheet1Xml));
        NodeList rowNodes = sheetDoc.getElementsByTagName("row");

        for (int i = 0; i < rowNodes.getLength(); i++) {
            Element rowEl = (Element) rowNodes.item(i);
            NodeList cNodes = rowEl.getElementsByTagName("c");
            Map<Integer, String> cellMap = new HashMap<>();

            for (int j = 0; j < cNodes.getLength(); j++) {
                Element cEl = (Element) cNodes.item(j);
                String cellRef = cEl.getAttribute("r"); // Ví dụ: "A2", "B2", "C2"
                int colIndex = getColumnIndex(cellRef);
                String type = cEl.getAttribute("t");

                String val = "";
                NodeList vNodes = cEl.getElementsByTagName("v");
                if (vNodes.getLength() > 0) {
                    String vText = vNodes.item(0).getTextContent();
                    if ("s".equals(type)) {
                        // Shared string index
                        try {
                            int sIndex = Integer.parseInt(vText);
                            if (sIndex >= 0 && sIndex < sharedStrings.size()) {
                                val = sharedStrings.get(sIndex);
                            }
                        } catch (NumberFormatException ignored) {
                        }
                    } else {
                        val = vText;
                    }
                } else {
                    NodeList isNodes = cEl.getElementsByTagName("is");
                    if (isNodes.getLength() > 0) {
                        val = isNodes.item(0).getTextContent();
                    }
                }
                cellMap.put(colIndex, val != null ? val.trim() : "");
            }

            if (!cellMap.isEmpty()) {
                int maxCol = 0;
                for (int col : cellMap.keySet()) {
                    if (col > maxCol) maxCol = col;
                }
                List<String> rowList = new ArrayList<>();
                for (int c = 0; c <= Math.max(maxCol, 6); c++) {
                    rowList.add(cellMap.getOrDefault(c, ""));
                }
                rawRows.add(rowList);
            }
        }

        return convertRowsToWords(rawRows);
    }

    /**
     * Đọc tệp CSV (UTF-8)
     */
    public static List<Word> parseCsv(InputStream is) throws Exception {
        List<List<String>> rows = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Bỏ qua BOM nếu có
                if (line.startsWith("\uFEFF")) {
                    line = line.substring(1);
                }
                line = line.trim();
                if (line.isEmpty()) continue;

                // Tách dòng theo tab, phẩy hoặc pipe
                List<String> cols = parseCsvLine(line);
                if (!cols.isEmpty()) {
                    rows.add(cols);
                }
            }
        }
        return convertRowsToWords(rows);
    }

    /**
     * Phân tích văn bản sao chép trực tiếp từ bảng tính Excel
     */
    public static List<Word> parsePastedText(String rawText) {
        List<List<String>> rows = new ArrayList<>();
        if (rawText == null || rawText.trim().isEmpty()) {
            return new ArrayList<>();
        }

        String[] lines = rawText.split("\\r?\\n");
        for (String line : lines) {
            line = line.trim();
            if (line.isEmpty()) continue;
            List<String> cols = parseCsvLine(line);
            if (!cols.isEmpty()) {
                rows.add(cols);
            }
        }
        return convertRowsToWords(rows);
    }

    private static List<String> parseCsvLine(String line) {
        List<String> tokens = new ArrayList<>();
        char delimiter = ',';
        if (line.contains("\t")) {
            delimiter = '\t';
        } else if (line.contains("|")) {
            delimiter = '|';
        }

        StringBuilder sb = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '\"') {
                inQuotes = !inQuotes;
            } else if (ch == delimiter && !inQuotes) {
                tokens.add(sb.toString().trim());
                sb.setLength(0);
            } else {
                sb.append(ch);
            }
        }
        tokens.add(sb.toString().trim());
        return tokens;
    }

    private static List<Word> convertRowsToWords(List<List<String>> rawRows) {
        List<Word> words = new ArrayList<>();
        for (int i = 0; i < rawRows.size(); i++) {
            List<String> row = rawRows.get(i);
            if (row.isEmpty()) continue;

            String hanzi = getCol(row, 0);
            String pinyin = getCol(row, 1);
            String meaningVi = getCol(row, 2);
            String hskStr = getCol(row, 3);
            String topic = getCol(row, 4);
            String exampleSentence = getCol(row, 5);
            String exampleMeaningVi = getCol(row, 6);

            // Bỏ qua dòng Header nếu có
            if (i == 0 && (hanzi.toLowerCase().contains("hanzi") || hanzi.toLowerCase().contains("hán tự") || hanzi.contains("Hán"))) {
                continue;
            }

            // Bắt buộc phải có chữ Hán và Nghĩa
            if (hanzi.isEmpty() || meaningVi.isEmpty()) {
                continue;
            }

            // Mặc định HSK Level
            int hskLevel = 1;
            try {
                if (!hskStr.isEmpty()) {
                    // Xóa chữ "HSK" nếu có trong chuỗi (vd: "HSK 1" -> 1)
                    String numStr = hskStr.replaceAll("[^0-9]", "");
                    if (!numStr.isEmpty()) {
                        hskLevel = Integer.parseInt(numStr);
                    }
                }
            } catch (Exception ignored) {
                hskLevel = 1;
            }
            if (hskLevel < 1 || hskLevel > 6) hskLevel = 1;

            if (topic.isEmpty()) topic = "Từ vựng chung";

            Word w = new Word(hanzi, pinyin, meaningVi, hskLevel, topic, exampleSentence, exampleMeaningVi, "");
            words.add(w);
        }
        return words;
    }

    private static String getCol(List<String> row, int index) {
        if (index < row.size() && row.get(index) != null) {
            return row.get(index).trim();
        }
        return "";
    }

    private static int getColumnIndex(String cellRef) {
        if (cellRef == null || cellRef.isEmpty()) return 0;
        int col = 0;
        for (int i = 0; i < cellRef.length(); i++) {
            char ch = cellRef.charAt(i);
            if (Character.isLetter(ch)) {
                col = col * 26 + (Character.toUpperCase(ch) - 'A' + 1);
            } else {
                break;
            }
        }
        return Math.max(0, col - 1);
    }

    private static byte[] readBytes(InputStream is) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        byte[] buffer = new byte[4096];
        int len;
        while ((len = is.read(buffer)) != -1) {
            baos.write(buffer, 0, len);
        }
        return baos.toByteArray();
    }
}
