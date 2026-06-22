# Execution Lock

## canvas
- viewBox: 0 0 1280 720
- format: PPT 16:9

## colors
- bg: #FFFFFF
- bg_secondary: #F4F7F6
- primary: #0E7C66
- primary_dark: #0A5A49
- accent: #F2811D
- text: #1F2A33
- text_secondary: #5B6B73
- border: #E2E8E9
- success: #2E9E5B
- warning: #E0544A
- text_muted: #94A3B8
- accent_dark: #C2610A
- success_dark: #1F7A45
- border_strong: #CBD5E1

## typography
- font_family: "Microsoft YaHei", Arial, sans-serif
- code_family: Consolas, "Courier New", monospace
- body: 20
- title: 36
- subtitle: 26
- annotation: 14
- cover_title: 60
- hero_number: 40
- footnote: 12

## icons
- library: tabler-outline
- stroke_width: 2
- inventory: leaf, eye-check, scan, camera, upload, device-mobile, route, map-pin, target, circle-check, clock, calendar-event, flag, chart-bar, chart-pie, chart-dots, users, user-circle, settings, qrcode, list-check, clipboard-check, shield-check, stack, layout-grid, box, cpu, filter-cog, ruler, palette, server, database, cloud, folder, photo, code, table, key, link-plus, git-branch, adjustments-horizontal, arrows-split, bug, flask-2, bulb, star, sparkles, alert-triangle, package, file-text, video

## page_rhythm
- P01: breathing
- P02: anchor
- P03: dense
- P04: dense
- P05: anchor
- P06: dense
- P07: dense
- P08: anchor
- P09: dense
- P10: dense
- P11: anchor
- P12: anchor
- P13: dense
- P14: dense
- P15: dense
- P16: dense
- P17: dense
- P18: breathing

## page_charts
- P02: agenda_list
- P04: harvey_balls_table
- P05: kpi_cards
- P06: labeled_card
- P08: concentric_circles
- P09: process_flow
- P10: vertical_pillars
- P11: layered_architecture
- P12: pipeline_with_stages
- P14: gantt_chart
- P15: team_roster
- P16: basic_table
- P17: icon_grid
- P18: vertical_list

## forbidden
- Mixing icon libraries
- rgba()
- `<style>`, `class`, `<foreignObject>`, `textPath`, `@font-face`, `<animate*>`, `<script>`, `<iframe>`, `<symbol>`+`<use>`
- `<g opacity>` (set opacity on each child element individually)
- HTML named entities in text (`&nbsp;`, `&mdash;`, `&copy;` …) — write as raw Unicode; XML reserved chars `& < > " '` escaped as `&amp; &lt; &gt; &quot; &apos;`
