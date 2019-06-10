Attribute VB_Name = "Module1"
Sub Easy()

'Create worksheet loop
    For Each ws In Worksheets

    'Determine values and varibles
        Dim Ticker_Name As String
        Dim Stock_Volume As Double
        Dim lastrow As Long
        Stock_Volume = 0
        Table_Row = 2
        lastrow = ws.Cells(Rows.Count, 1).End(xlUp).Row

    'Create Headers for new columns
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Total Stock Volume"

    'Create loop to review column information
        For I = 2 To lastrow
        
        'Create if statement that compares the values in column 1
            If ws.Cells(I, 1).Value <> ws.Cells((I + 1), 1).Value Then
            
        'If Ticker values are different then...
        'Add to the stock volume
            Stock_Volume = Stock_Volume + ws.Cells(I, 7)
        
        'Enter the Ticker Name and Stock Volume in the new table
            Ticker_Name = ws.Cells(I, 1).Value
            ws.Range("I" & Table_Row) = Ticker_Name
            ws.Range("J" & Table_Row) = Stock_Volume

        'Move Table Row down 1 row and reset Stock Volume
            Table_Row = Table_Row + 1
            Stock_Volume = 0
                
        'If Ticker values are the same then add to the Stock Volume
            Else: Stock_Volume = Stock_Volume + ws.Cells(I, 7)
    
            End If
            
        Next I
        
    'Auto Fit Columns
        ws.Columns.AutoFit
        
    Next ws

'Calulation Complete
    MsgBox ("Calculation Complete")

End Sub
