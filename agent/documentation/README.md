# Tips
- Use CTRL + SHIFT + V to open the `.md` preview.
- Use this playground generate the imgs for the diagrams: [mermaid playground](https://www.mermaidchart.com/play?utm_source=mermaid_live_editor&utm_medium=toggle#pako:eNqrVkrOT0lVslJSqgUAFW4DVg)

- for-pdf-export has imgs instead of ```mermaid``` blocks. Used for exporting to pdfs.
1. Copy and paste `documentation.md` into `documentation-[for-pdf-export].md`.
2. Replace mermaid diagrams with this: 
<p align="center">
  <img src="images/img_x.png" alt="Main Conversation Flow">
</p>

where x is the img number (starting from 1).
3. Generate the imgs using `generate_mermaid_images.sh`.
4. Manually export it using right-click on the md file (on the text editor, not the directory view)