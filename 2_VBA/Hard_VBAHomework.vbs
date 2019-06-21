Attribute VB_Name = "Module3"
Sub Hard()

'Select starting worksheet
    Worksheets("2016").Activate

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
          
    'Determine values and varibles
        Dim lastrow2 As Long
        Dim Greatest_Increase As Double
        Dim Greatest_Decrease As Double
        Dim Greatest_Volume As Double
        Dim Inrease_Num As Range
        Dim Decrease_Num As Range
        Dim Volume_Num As Range
        lastrow2 = Cells(Rows.Count, 11).End(xlUp).Row
    
    'Create Headers and Rows of New Table
        ws.Range("P1").Value = "Ticker"
        ws.Range("Q1").Value = "Value"
        ws.Range("O2").Value = "Greatest % Increase"
        ws.Range("O3").Value = "Greatest % Decrease"
        ws.Range("O4").Value = "Greatest Total of Volume"
           
        
    'Return Greatest % Increase, % Decrease and Volume with the Ticker name

        Greatest_Increase = WorksheetFunction.Max(ws.Range("K2:K" & lastrow2))
        Greatest_Decrease = WorksheetFunction.Min(ws.Range("K2:K" & lastrow2))
        Greatest_Volume = WorksheetFunction.Max(ws.Range("L2:L" & lastrow2))

        Set Increase_Num = ws.Range("K2:K" & lastrow2).Find(what:=Greatest_Increase)
        Set Decrease_Num = ws.Range("K2:K" & lastrow2).Find(what:=Greatest_Decrease)
        Set Volume_Num = ws.Range("L2:L" & lastrow2).Find(what:=Greatest_Volume)
        
        ws.Range("Q2").Value = Increase_Num.Offset(, 0).Value
        ws.Range("P2").Value = Increase_Num.Offset(, -2).Value
        
        ws.Range("Q3").Value = Decrease_Num.Offset(, 0).Value
        ws.Range("P3").Value = Decrease_Num.Offset(, -2).Value
        
        ws.Range("Q4").Value = Volume_Num.Offset(, 0).Value
        ws.Range("P4").Value = Volume_Num.Offset(, -3).Value
        
    'Formant percentages
        ws.Range("K2:K" & Table_Row).NumberFormat = "0.00%"
        ws.Range("Q2:Q3").NumberFormat = "0.00%"
        
     'Autofir Columns
        ws.Columns.AutoFit
    
    Next ws

'Calulation Complete
    MsgBox ("Calculation Complete")

End Sub

