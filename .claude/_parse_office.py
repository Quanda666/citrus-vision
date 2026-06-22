# -*- coding: utf-8 -*-
import sys, zipfile, re
import xml.etree.ElementTree as ET

try:
    sys.stdout.reconfigure(encoding='utf-8')
except Exception:
    pass

W = '{http://schemas.openxmlformats.org/wordprocessingml/2006/main}'

def localname(tag):
    return tag.split('}', 1)[-1] if '}' in tag else tag

def parse_docx(path):
    z = zipfile.ZipFile(path)
    xml = z.read('word/document.xml')
    root = ET.fromstring(xml)
    out = []

    def walk(elem):
        tag = localname(elem.tag)
        if tag == 'tbl':
            # 表格：逐行逐单元格
            for tr in elem.iter(W + 'tr'):
                cells = []
                for tc in tr.findall(W + 'tc'):
                    txt = ''.join(t.text or '' for t in tc.iter(W + 't'))
                    cells.append(txt.strip())
                out.append(' | '.join(cells))
            out.append('')  # 表格后空行
            return
        if tag == 'p':
            txt = ''.join(t.text or '' for t in elem.iter(W + 't'))
            out.append(txt)
            return
        for child in elem:
            walk(child)

    body = root.find(W + 'body')
    if body is None:
        body = root
    for child in body:
        walk(child)
    return '\n'.join(out)

def col_to_idx(col):
    idx = 0
    for ch in col:
        idx = idx * 26 + (ord(ch) - ord('A') + 1)
    return idx - 1

def parse_xlsx(path):
    z = zipfile.ZipFile(path)
    # shared strings
    shared = []
    if 'xl/sharedStrings.xml' in z.namelist():
        sroot = ET.fromstring(z.read('xl/sharedStrings.xml'))
        for si in sroot:
            txt = ''.join(t.text or '' for t in si.iter() if localname(t.tag) == 't')
            shared.append(txt)
    # sheet name mapping
    names = z.namelist()
    sheets = sorted([n for n in names if re.match(r'xl/worksheets/sheet\d+\.xml$', n)])
    result = []
    for sh in sheets:
        result.append('==== %s ====' % sh)
        sroot = ET.fromstring(z.read(sh))
        for row in sroot.iter():
            if localname(row.tag) != 'row':
                continue
            cells = {}
            maxc = -1
            for c in row:
                if localname(c.tag) != 'c':
                    continue
                ref = c.get('r', '')
                colpart = re.match(r'[A-Z]+', ref)
                cidx = col_to_idx(colpart.group()) if colpart else 0
                t = c.get('t', '')
                val = ''
                for child in c:
                    if localname(child.tag) == 'v':
                        val = child.text or ''
                    elif localname(child.tag) == 'is':
                        val = ''.join(x.text or '' for x in child.iter() if localname(x.tag) == 't')
                if t == 's' and val.isdigit():
                    val = shared[int(val)] if int(val) < len(shared) else val
                cells[cidx] = val
                maxc = max(maxc, cidx)
            rowvals = [cells.get(i, '') for i in range(maxc + 1)]
            result.append(' | '.join(rowvals))
        result.append('')
    return '\n'.join(result)

if __name__ == '__main__':
    path = sys.argv[1]
    if path.lower().endswith('.docx'):
        print(parse_docx(path))
    elif path.lower().endswith('.xlsx'):
        print(parse_xlsx(path))
