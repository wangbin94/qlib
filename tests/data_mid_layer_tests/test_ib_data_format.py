#!/usr/bin/env python3

import qlib
import pandas as pd

def test_hf_data_format():
    """Test the high-frequency data format and available time ranges"""
    
    print("🔍 Testing IB 5min Data Format...")
    
    # Initialize qlib
    qlib.init(provider_uri='~/.qlib/qlib_data/ib_data/5min', region='us')
    
    from qlib.data import D
    
    # Test basic data access
    try:
        data = D.features(['SPY'], ['$close'], start_time='2022-01-01', end_time='2022-01-10')
        if data is not None and not data.empty:
            print('✅ Basic data access works!')
            print(f'Shape: {data.shape}')
            print(f'Date range: {data.index.get_level_values("datetime").min()} to {data.index.get_level_values("datetime").max()}')
            print('Sample times:')
            sample_times = data.index.get_level_values('datetime').unique()[:10]
            for time in sample_times:
                print(f'  {time}')
        else:
            print('❌ No data found for basic test')
    except Exception as e:
        print(f'❌ Basic data access failed: {e}')
    
    # Test with specific trading hours
    print('\n📊 Testing with specific trading hours...')
    try:
        # Test a full trading day
        data = D.features(['SPY', 'QQQ'], ['$close', '$volume'], 
                         start_time='2022-01-03 09:30:00', end_time='2022-01-03 16:00:00')
        if data is not None and not data.empty:
            print('✅ Trading hours data access works!')
            print(f'Shape: {data.shape}')
            unique_times = data.index.get_level_values('datetime').unique()
            print(f'Trading periods in day: {len(unique_times)}')
            print(f'First: {unique_times.min()}')
            print(f'Last: {unique_times.max()}')
        else:
            print('❌ No trading hours data found')
    except Exception as e:
        print(f'❌ Trading hours test failed: {e}')
    
    # Test date range availability
    print('\n📅 Testing date range availability...')
    test_dates = [
        '2019-01-03',
        '2020-01-03', 
        '2021-01-03',
        '2022-01-03',
        '2023-01-03',
        '2024-01-03'
    ]
    
    for test_date in test_dates:
        try:
            data = D.features(['SPY'], ['$close'], 
                             start_time=test_date, end_time=test_date)
            if data is not None and not data.empty:
                count = len(data)
                print(f'✅ {test_date}: {count} data points')
            else:
                print(f'❌ {test_date}: No data')
        except Exception as e:
            print(f'❌ {test_date}: Error - {e}')

if __name__ == "__main__":
    test_hf_data_format() 