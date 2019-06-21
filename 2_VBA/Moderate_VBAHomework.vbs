Attribute VB_Name = "Module2"
Sub Moderate()

'Create worksheet loop
    For Each ws In Worksheets

    'Determine values and varibles
        Dim Ticker_Name As String
        Dim Yearly_Change As Single
        Dim Percent_Change As Double
        Dim Stock_Volume As Double
        Dim Day_Count As Long
        Dim lastrow As Long
        Stock_Volume = 0
        Table_Row = 2
        Day_Count = 0
        lastrow = ws.Cells(Rows.Count, 1).End(xlUp).Row

    'Create Headers for new columns
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Yearly Change"
        ws.Range("K1").Value = "Percent Change"
        ws.Range("L1").Value = "Total Stock Volume"

    'Create loop to review column information
        For I = 2 To lastrow
  
        'Create if statement that compares the values in column 1
            If ws.Cells(I, 1).Value <> ws.Cells((I + 1), 1).Value Then
            
        'If Ticker values are different then...
        
        'Grab the Opening and Closing Price of the Ticker
            Dim Yearly_Open As Double
            Yearly_Open = ws.Cells(I - Day_Count, 3)
            Dim Yearly_Close As Double
            Yearly_Close = ws.Cells(I, 6)
            
        'Calculate the Yearly Change and Percent Change
            Yearly_Change = Yearly_Close - Yearly_Open
            
            'Some Stock Tickers have a 0 for opening price and end price
            'If statement to avoid getting an error for 0/0 in the ELSE calcuation below
                If Yearly_Open = 0 Or Yearly_Close = 0 Then
                Percent_Change = 0
                
                Else:
                Percent_Change = (Yearly_Close / Yearly_Open) - 1
        
                End If
                
        'Add to the stock volume
            Stock_Volume = Stock_Volume + ws.Cells(I, 7)
        
        'Enter the Ticker Name and Stock Volume in the new table
            Ticker_Name = ws.Cells(I, 1).Value
            ws.Range("I" & Table_Row) = Ticker_Name
            ws.Range("J" & Table_Row) = Yearly_Change
            ws.Range("K" & Table_Row) = Percent_Change
            ws.Range("L" & Table_Row) = Stock_Volume

        'Format new table
            ws.Range("K" & Table_Row).NumberFormat = "0.00%"
            
                If ws.Range("J" & Table_Row).Value >= 0 Then
                ws.Range("J" & Table_Row).Interior.ColorIndex = 4
            
                Else
                ws.Range("J" & Table_Row).Interior.ColorIndex = 3
                
                End If
            
        'Move Table Row down 1 row and reset Stock Volume and Day Count
            Table_Row = Table_Row + 1
            Stock_Volume = 0
            Day_Count = 0
            
        'If Ticker values are the same then add to the Stock Volume and Day Count
            Else:
            Stock_Volume = Stock_Volume + ws.Cells(I, 7)
            Day_Count = Day_Count + 1
            
            End If
            
        Next I
        
    'Auto Fit Columns
        ws.Columns.AutoFit
        
    Next ws

'Calulation Complete
    MsgBox ("Calculation Complete")

End Sub

