//
//  FirstViewController.swift
//  RWA App
//
//  Created by Александр on 08.04.2019.
//  Copyright © 2019 Alexander Melnichuk. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var toraTextField: UITextField!
    @IBOutlet weak var todaTextField: UITextField!
    @IBOutlet weak var asdaTextField: UITextField!
    @IBOutlet weak var elevTextField: UITextField!
    @IBOutlet weak var slopeTextField: UITextField!
    @IBOutlet weak var hdgTextField: UITextField!
    
    
    @IBOutlet weak var rwconditionSegmented: UISegmentedControl!
    @IBOutlet weak var kscepTextField: UITextField!
    @IBOutlet weak var oatTextField: UITextField!
    @IBOutlet weak var qnhTextField: UITextField!
    @IBOutlet weak var windspeedTextField: UITextField!
    @IBOutlet weak var winddirTextField: UITextField!
    @IBOutlet weak var mTextField: UITextField! // масса
    
    @IBOutlet weak var calculationsresult: UILabel!
    
    @IBAction func calcTapped(_ sender: UIButton) {
        
      /*  // Исходные данные по аэродрому
        var tora: Double = 3000 // РДР
        var toda: Double = 3400 // РДВ
        var asda: Double = 3000 // РДПВ
        var elev: Double = 207
        var slope: Double = -0.433 //уклон ВПП
        
        //Исходные данные по ВС
        var m_max: Double = 105000
    
        //ввод данных
        var rwCondition: Int = 1//состояние ВПП (1 - сух, 2 - сляк, 3 - снег)
        var kBR: Double = 0.6 //коэффициент сцепления
        var headwind: Double = 2.2
        var m_vzl: Double = 99116
        var t: Double = 20
        var qfe: Double = 991
        //var trip_fuel: Double = 26000
        var m_vlz_fakt: Double = m_vzl */
        
        
        // Исходные данные по аэродрому
        var tora: Double = Double(toraTextField.text!)!
        var toda: Double = Double(todaTextField.text!)!
        var asda: Double = Double(asdaTextField.text!)!
        var elev: Double = Double(elevTextField.text!)!
        var slope: Double = Double(slopeTextField.text!)!
        var hdg: Double = Double(hdgTextField.text!)! // heading of the runway
        var brit: Bool = false
        
        //Исходные данные по ВС
        var m_max: Double = 105000
        
        //ввод данных
        var rwCondition: Int = 1//состояние ВПП (1 - сух, 2 - сляк, 3 - снег)
        var kBR: Double = Double(kscepTextField.text!)! //коэффициент сцепления
        var m_vzl: Double = Double(mTextField.text!)! //взлетная масса f18 на loadsheet
        var t: Double = Double(oatTextField.text!)!
        var qnh: Double = Double(qnhTextField.text!)!
        //var trip_fuel: Double = 26000
        var m_vlz_fakt: Double = m_vzl
        var wind_dir: Double = Double(winddirTextField.text!)! //направление ветра
        var wind_speed: Double = Double(windspeedTextField.text!)! //скорость ветра
        if rwconditionSegmented.selectedSegmentIndex == 0 {
            rwCondition = 1
        } else if rwconditionSegmented.selectedSegmentIndex == 1 {
            rwCondition = 2
        } else if rwconditionSegmented.selectedSegmentIndex == 2 {
            rwCondition = 3
        }
        
        //ПРЕОБРАЗОВАНИЕ ВВЕДЕННЫХ ДАННЫХ
        var qfe: Double
        var hPa: Double
        var headwind: Double
        var crosswind: Double
        var sub_angle: Double
        var sub_angle_rad: Double
        // - давление на аэродроме
        hPa = -4.6708 * pow(10,(-7)) * pow(elev, 2) + 0.0363 * elev + 0.1842
        if brit == true {
            qfe = qnh - hPa
        } else {
            qfe = qnh - hPa * 3.2808
        }
        // ветер
        let pi = 3.14159
        sub_angle = wind_dir - hdg
        sub_angle_rad = sub_angle *  pi / 180
        crosswind = sin(sub_angle_rad) * wind_speed
        headwind = cos(sub_angle_rad) * wind_speed
        
        //БЛОК 1 Скорректированная располагаемая дистанция продолженного взлета (ЧР)
        var tora_z: Double
        var tora_b4: Double
        var tora_d2: Double
        var min: Double
        var min_e4: Double
        var min_f4: Double
        var min_vspom: Double
        tora_z = tora - 50
        if rwCondition == 2 || rwCondition == 3 {
            tora_b4 = tora_z * 0.83333333333
        } else {
            tora_b4 = tora_z
        }
        if tora_b4 <= 1800 {
            tora_d2 = 1.125 * tora_b4 + 25
        } else if (tora_b4 > 1800) && (tora_b4 <= 3400) {
            tora_d2 = 1.0625 * tora_b4 + 137.5
        } else {
            tora_d2 = 1.03 * tora_b4 + 248
        }
        // - по уклону (начало)
        if toda < tora_d2 {
            min = toda
        } else {
            min = tora_d2
        }
        if slope > 0 {
            min_e4 = ((0.841667 * min + 53.3333) - min) * (0.5 * slope) + min
        } else {
            min_vspom = (1.16667 * min - 66.6667) - min
            min_e4 = min_vspom * ( -0.5 * slope) + min
        }
        // - по уклону (конец)
        // - по ветру (начало)
        if headwind < 0 {
            min_f4 = (( 0.895833 * min_e4 - 83.3333) - min_e4) * ( -0.2 * headwind) + min_e4
        } else {
            min_f4 = ((1.225 * min_e4 + 100) - min_e4) * (0.05 * headwind) + min_e4
        }
        // - по ветру (конец)
        
        //БЛОК 2 Располагаемая дистанция прерванного взлета (РДПВ) с учетом слоя осадков на ВПП
        var  asda_bez_osad: Double
        var asda_slak: Double
        var asda_snow: Double
        var asda_final_d3: Double = 0
        if rwCondition == 1 {
            asda_final_d3 = asda - 50 //без осадков
        } else if rwCondition == 2 {
            asda_final_d3 = (asda - 50)*0.584333 //Слякоть 3-12мм Мокрый снег
        } else {
            asda_final_d3 = (asda - 50)*0.622333 //Снег 10-50мм сухой
        }
    
        //БЛОК 3 Скорректированная располагаемая дистанция прерванного взлета (РДПВ)
        var  kRWCondition: Double
        var asda_final_a4: Double
        var vspom: Double //вспомогательная переменная
        var vspom2: Double
        var asda_korr_b4: Double = 0
        if rwCondition == 2 || rwCondition == 3 {
           kRWCondition = 0.57
        }
        if rwCondition == 1 && kBR > 0.57 {
            kRWCondition = 0.57
        } else {
            kRWCondition = kBR
        }
        asda_final_a4 = asda_final_d3 - (1 - ( -0.00000228938 * asda_final_d3 + 0.628663)) * asda_final_d3 * ( -3.7036 * kRWCondition + 2.1111)
        if headwind < 0 {
            asda_korr_b4 = asda_final_a4 - (( 1 - (0.0000151515 * asda_final_a4 + 0.639394)) * ((-headwind/5)) * asda_final_a4)
        } else {
            vspom = ( -0.0000127093 * asda_final_a4 + 1.36408) - 1;
            vspom2 = vspom * (headwind / 20) + 1;
            asda_korr_b4 = vspom2 * asda_final_a4
        }
   
        //БЛОК 4 Приведенная взлетная масса и относительная скорость принятия решения V1/V п.ст в зависимости от скорректированных располагаемых дистанций
        var v1_vr: Double
        var pre_m_vzl_b4: Double
        var priv_m_vzl_b5: Double
        if ((0.00022222 * asda_korr_b4 + 0.6067) - ( -0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)) * (0.00000012302 * pow(min_f4, 2) - 0.0010766 * min_f4 + 2.3381) + ( -0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553) > 1 {
            v1_vr = 1
        } else {
            v1_vr = ((0.00022222 * asda_korr_b4 + 0.6067) - ( -0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)) * (0.00000012302 * pow(min_f4, 2) - 0.0010766 * min_f4 + 2.3381) + ( -0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)
        }
        pre_m_vzl_b4 = (((0.0124 * min_f4 + 92.1754 ) - (0.000000000839986 * pow(min_f4, 3) - 0.00000820431 * pow(min_f4, 2) + 0.0386714 * min_f4 + 46.8137)) * (0.00058823 * asda_korr_b4 - 0.8823) + (0.000000000839986 * pow(min_f4, 3) - 0.00000820431 * pow(min_f4, 2) + 0.0386714 * min_f4 + 46.8137)) * 1000
        if pre_m_vzl_b4 > 126000 {
            priv_m_vzl_b5 = 126000
        } else {
            priv_m_vzl_b5 = pre_m_vzl_b4
        }
    
        // БЛОК 5 Скорости на взлете с закрылками 18 (предкрылки 19)
        var v_pst: Double
        var v_2: Double
        v_pst = 1.2001 * (m_vzl / 1000)  + 118.9931 // Vп.ст.
        v_2 = v_pst + 20
        
        
        // БЛОК 6 гПа ---> мм.рт.ст
        var mm_rt_st: Double
        var height_c2: Double
        mm_rt_st = qfe * 0.75
        height_c2 = (0.0078727 * pow(mm_rt_st, 2) - 22.9056 * mm_rt_st + 12861.4077)
        
        
        // БЛОК 7 Взлетная масса самолета в зависимости от приведенной массы и условий на аэродроме
        var m_b8: Double
        var m_b8_vspom: Double
        var m_b8_vspom2: Double
        var m_vzl_b10: Double
        if t<0 {
            m_b8_vspom2 = -0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200
            m_b8_vspom = m_b8_vspom2 - (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)
            m_b8 = m_b8_vspom * (0.02 * t + 1) + (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)
        } else if (t > (31 - 0.007 * height_c2)) && (height_c2 >= 2000) && (height_c2 <= 3000) {
            m_b8 = ((18.5 * height_c2 + 104500) - (17.5 * height_c2 + 67500)) * (0.025 * t - 0.25) + (17.5 * height_c2 + 67500)
        } else if t>(31 - 0.007 * height_c2) && height_c2 >= 1000 && height_c2 <= 2000 {
            m_b8 = ((23 * height_c2 + 95500) - (15 * height_c2 + 79000)) * (0.030303 * t - 0.515152) + (15 * height_c2 + 79000)
        } else if t > (36 - 0.012 * height_c2) && height_c2 >= 0 && height_c2 <= 1000 {
            m_b8 = ((11.7 * height_c2 + 107000) - (17 * height_c2 + 82000)) * (0.0384615 * t - 0.923077) + (17 * height_c2 + 82000)
        } else {
            m_b8 = ((-0.0000009 * pow(height_c2, 3) + 0.0053 * pow(height_c2, 2) + 2.6 * height_c2 + 96800)-(-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)) * 0.02 * t + (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)
        }
        if (priv_m_vzl_b5 - m_b8) > 0 {
            m_vzl_b10 = 110000 - ((0.00000375 * pow(m_b8, 2) + 0.425 * m_b8 + 42000) - priv_m_vzl_b5) / ((0.00000375 * pow(m_b8, 2) + 0.425 * m_b8 + 42000) - m_b8) * 20000
        } else {
            m_vzl_b10 = ((0.000000118519 * pow(m_b8, 2) + 0.802519 * m_b8 - 2857.04) - priv_m_vzl_b5) / ((0.000000118519 * pow(m_b8, 2) + 0.802519 * m_b8 - 2857.04) - m_b8) * 20000 + 70000
        }
        
        
         // БЛОК 8 Взлетная масса самолета в зависимости от MAX приведенной массы 114 т. и условий на аэродроме
        var m_b8_blok_8: Double
        var m_b9_blok_8: Double = 114000
        var m_b10_blok8: Double
        if t < 0 {
            m_b8_blok_8 = ((-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200) - (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)) * (0.02 * t + 1) + (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 2000 && height_c2<=3000 {
            m_b8_blok_8 = ((18.5 * height_c2 + 104500) - (17.5 * height_c2 + 67500)) * (0.025 * t - 0.25) + (17.5 * height_c2 + 67500)
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 1000 && height_c2 <= 2000 {
            m_b8_blok_8 = ((23 * height_c2 + 95500) - (15 * height_c2 + 79000)) * (0.030303 * t - 0.515152) + (15 * height_c2 + 79000)
        } else if t > (36 - 0.012 * height_c2) && height_c2 >= 0 && height_c2 <= 1000 {
            m_b8_blok_8 = ((11.7 * height_c2 + 107000) - (17 * height_c2 + 82000)) * (0.0384615 * t - 0.923077) + (17 * height_c2 + 82000)
        } else {
            m_b8_blok_8 = ((-0.0000009 * pow(height_c2, 3) + 0.0053 * pow(height_c2, 2) + 2.6 * height_c2 + 96800)-(-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)) * 0.02 * t + (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)
        }
        if (m_b9_blok_8 - m_b8_blok_8) > 0 {
            m_b10_blok8 = 110000 - ((0.00000375 * pow(m_b8_blok_8, 2) + 0.425 * m_b8_blok_8 + 42000) - m_b9_blok_8) / ((0.00000375 * pow(m_b8_blok_8, 2) + 0.425 * m_b8_blok_8 + 42000) - m_b8_blok_8) * 20000
        } else {
            m_b10_blok8 = ((0.000000118519 * pow(m_b8_blok_8, 2) + 0.802519 * m_b8_blok_8 - 2857.04) - m_b9_blok_8) / ((0.000000118519 * pow(m_b8_blok_8, 2) + 0.802519 * m_b8_blok_8 - 2857.04) - m_b8_blok_8) * 20000 + 70000
        }
        
        
        // БЛОК 9 Взлетная масса, ограниченная градиентом набора высоты с одним неработающим двигателем
        var m_b9_blok9: Double
        if t <= 10 && height_c2 >= 2000 {
            m_b9_blok9 = (120750 - 9.875 * height_c2)
        } else if t <= 15 && height_c2 >= 1539 && height_c2 <= 2000 {
            m_b9_blok9 = (118061 - 8.48485 * height_c2)
        } else if (3200 - 60 * t) > height_c2 && t <= 35 && t >= 30 {
            m_b9_blok9 = ((116364 - 12.7273 * height_c2) - (113000 - 13.75 * height_c2)) * (7 - 0.2 * t) + (113000 - 13.75 * height_c2)
        } else if (3200 - 60 * t) > height_c2 && t <= 30 && t >= 25 {
            m_b9_blok9 = ((124462 - 15.3846 * height_c2) - (116364 - 12.7273 * height_c2)) * (6 - 0.2 * t) + (116364 - 12.7273 * height_c2)
        } else if (2200 - 20 * t) > height_c2 && t <= 25 && t >= 20 {
            m_b9_blok9 = ((119430 - 10.596 * height_c2) - (124462 - 15.3846 * height_c2)) * (5 - 0.2 * t) + (124462 - 15.3846 * height_c2)
        } else if (2600 - 40 * t) > height_c2 && t <= 20 && t >= 15 {
            m_b9_blok9 = ((118061 - 8.48485 * height_c2) - (119430 - 10.596 * height_c2)) * (4 - 0.2 * t) + (119430 - 10.596 * height_c2)
        } else if t >= 10 && t <= 15 {
            m_b9_blok9 = ((120750 - 9.875 * height_c2) - (126000 - 12.5 * height_c2)) * (3 - 0.2 * t) + (126000 - 12.5 * height_c2)
        } else if t >= 15 && t <= 20 {
            m_b9_blok9 = ((126000 - 12.5 * height_c2) - (123429 - 12.8571 * height_c2)) * (4 - 0.2 * t) + (123429 - 12.8571 * height_c2)
        } else if t >= 20 && t <= 25 {
            m_b9_blok9 = ((123429 - 12.8571 * height_c2) - (120726 - 13.242 * height_c2)) * (5 - 0.2 * t) + (120726 - 13.242 * height_c2)
        } else if t >= 25 && t <= 30 {
            m_b9_blok9 = ((120726 - 13.242 * height_c2) - (118457 - 14.3571 * height_c2)) * (6 - 0.2 * t) + (118457 - 14.3571 * height_c2)
        } else if t >= 30 && t <= 35 {
            m_b9_blok9 = ((118457 - 14.3571 * height_c2) - (113000 - 13.75 * height_c2)) * (7 - 0.2 * t) + (113000 - 13.75 * height_c2)
        } else {
            m_b9_blok9 = ((113000 - 13.75 * height_c2) - (107000 - 12.7778 * height_c2)) * (8 - 0.2 * t) + (107000 - 12.7778 * height_c2)
        }

        
        // БЛОК 10 Скорректированная располагаемая дистанция нормального взлета. (РДВ)(L1)
        var a4_blok10: Double
        var toda_b4_blok10: Double
        var toda_a2: Double
        toda_a2 = toda - 50
        if slope > 0 {
            a4_blok10 = (((0.0000118829 * toda_a2 + 0.1046) * slope / (-2)) + 1) * toda_a2
        } else {
            a4_blok10 = (((0.000014323 * toda_a2 + 0.1052) * slope / (-2)) + 1) * toda_a2
        }
        if headwind < 0 {
            toda_b4_blok10 = (1 - (0.000013021 * a4_blok10 + 0.8229)) * (headwind / 5) * a4_blok10 + a4_blok10
        } else {
            toda_b4_blok10 = ((-0.0000065099 * a4_blok10 + 0.276) * headwind / 20 + 1) * a4_blok10
        }
        
        
        // БЛОК 11 Взлетная масса, ограниченная взлетной дистанцией при нормальном взлете (РДВ)
        var s_blok_10: Double //подразумевается блок 11
        var izlom_t: Double
        var alfa_rud_b13_blok11: Double = 73
        var toda_b14_blok_11: Double
        var s_b16_blok11: Double // S'
        var k_vert_b17_blok11: Double
        var k_1000_b18_blok11: Double
        var b19_blok11: Double
        var k_2000_b20_blok11: Double
        var b21_blok11: Double
        var k_okon_b22_blok11: Double
        var b23_blok11: Double
        var b24_blok11: Double
        var m_vzl_b15_blok11: Double
        izlom_t = (-0.000000000166667 * pow(height_c2, 3) + 0.0000005 * pow(height_c2, 2) + 30 - 0.00633333 * height_c2)
        if height_c2 <= 3000 && height_c2 > 2000 && t > izlom_t {
            s_blok_10 = ((0.7 * height_c2 + 1350) - (0.45 * height_c2 + 350)) * (0.02 * t) + (0.45 * height_c2 + 350)
        } else if height_c2 <= 3000 && height_c2 > 2000 && t <= izlom_t && t > 0 {
            s_blok_10 = ((0.4 * height_c2 + 1100) - (0.43 * height_c2 + 760)) * (0.02 * t) + (0.43 * height_c2 + 760)
        } else if height_c2 <= 3000 && height_c2 > 2000 && t <= 0 {
            s_blok_10 = ((0.5 * height_c2 + 900) - (0.36 * height_c2 + 620)) * (0.01 * t + 0.5) + (0.36 * height_c2 + 620)
        } else if height_c2 <= 2000 && height_c2 > 1000 && t > izlom_t {
            s_blok_10 = ((0.62 * height_c2 + 1510) - (0.45 * height_c2 + 350)) * (0.02 * t) + (0.45 * height_c2 + 350)
        } else if height_c2 <= 2000 && height_c2 > 1000 && t <= izlom_t {
            s_blok_10 = ((0.34 * height_c2 + 1220) - (0.28 * height_c2 + 780)) * (0.01 * t + 0.5) + (0.28 * height_c2 + 780)
        } else if height_c2 <= 1000 && t > izlom_t {
            s_blok_10 = ((0.53 * height_c2 + 1600) - (0.15 * height_c2 + 650)) * (0.02 * t) + (0.15 * height_c2 + 650)
        } else {
            s_blok_10 = ((0.27 * height_c2 + 1290) - (0.1 * height_c2 + 960)) * (0.01 * t + 0.5) + (0.1 * height_c2 + 960)
        }
        toda_b14_blok_11 = (toda_b4_blok10 - (0.820513 * toda_b4_blok10 - 189.744)) * (0.0769231 * alfa_rud_b13_blok11 - 4.61538) + (0.820513 * toda_b4_blok10 - 189.744)
        s_b16_blok11 = (1.75 * s_blok_10 - 50)
        if (toda_b14_blok_11 - s_blok_10) / (s_b16_blok11 - s_blok_10) > 1 {
            k_vert_b17_blok11 = 1
        } else {
            k_vert_b17_blok11 = (toda_b14_blok_11 - s_blok_10) / (s_b16_blok11 - s_blok_10)
        }
        if (-0.291651 * pow(k_vert_b17_blok11, 2) + 1.29165 * k_vert_b17_blok11) < 0 {
            k_1000_b18_blok11 = 0
        } else if (-0.291651 * pow(k_vert_b17_blok11, 2) + 1.29165 * k_vert_b17_blok11) > 1 {
            k_1000_b18_blok11 = 1
        } else {
            k_1000_b18_blok11 = (-0.291651 * pow(k_vert_b17_blok11, 2) + 1.29165 * k_vert_b17_blok11)
        }
        b19_blok11 = k_1000_b18_blok11 * 30000 + 80000
        if (-0.530222 * pow(k_vert_b17_blok11, 2) + 1.53022 * k_vert_b17_blok11) < 0 {
            k_2000_b20_blok11 = 0
        } else if (-0.530222 * pow(k_vert_b17_blok11, 2) + 1.53022 * k_vert_b17_blok11) > 1 {
            k_2000_b20_blok11 = 1
        } else {
            k_2000_b20_blok11 = (-0.530222 * pow(k_vert_b17_blok11, 2) + 1.53022 * k_vert_b17_blok11)
        }
        b21_blok11 = k_2000_b20_blok11 * 30000 + 80000
        if (k_2000_b20_blok11 - k_1000_b18_blok11) * (0.000833333 * s_blok_10 - 0.833333) + k_1000_b18_blok11 > 1 {
            k_okon_b22_blok11 = 1
        } else {
            k_okon_b22_blok11 = (k_2000_b20_blok11 - k_1000_b18_blok11) * (0.000833333 * s_blok_10 - 0.833333) + k_1000_b18_blok11
        }
        b23_blok11 = k_okon_b22_blok11 * 30000 + 80000
        b24_blok11 = (0.000263889 * pow(s_blok_10, 2) + 0.997222 * s_blok_10 + 428.889)
        m_vzl_b15_blok11 = k_okon_b22_blok11 * 30000 + 80000
        /* b1 - t
        b2 - height_c2
        b3 - izlom_t
        b11 - s_blok_10
        b12 - toda_b4_blok10
        b13 - alfa_rud_b13_blok11
        b14 - toda_b14_blok_11
        b15 - m_vzl_b15_blok11
        b16 - s_b16_blok11
        b17 - k_vert_b17_blok11
        b18 - k_1000_b18_blok11
        b19 - b19_blok11
        b20 - k_2000_b20_blok11
        b21 - b21_blok11
        b22 - k_okon_b22_blok11
        b23 - b23_blok11
        b24 - b24_blok11 */
        
        
        // БЛОК 12 Скорректированная располагаемая длина разбега нормального взлета (РДР)
        var a4_blok12: Double // скорректированная по уклону
        var b4_blok12: Double // скорректированная по ветру
        if slope <= 0 {
            a4_blok12 = ((1.17292 * tora_z - 116.667) - tora_z) * (-0.5 * slope) + tora_z
        } else {
            a4_blok12 = (tora_z - (0.829167 * tora_z + 43.3333)) * (1 - 0.5 * slope) + (0.829167 * tora_z + 43.3333)
        }
        if slope >= 0 {
            b4_blok12 = ((1.16364 * a4_blok12 + 105.455) - a4_blok12) * (0.05 * headwind) + a4_blok12
        } else {
            b4_blok12 = (a4_blok12 - (0.875 * a4_blok12 - 150)) * (0.2 * headwind + 1) + (0.875 * a4_blok12 - 150)
        }
        /*
         a2 - tora_z
         a3 - slope
         a4 - a4_blok12
         b2 - a4_blok12
         b3 - headwind
         b4 - b4_blok12
         */
        
        
        // БЛОК 13 Взлетная масса, ограниченная длиной разбега при нормальном взлете(РДР)
        var izlom_t_blok13: Double
        var alfa_rud_b14_blok13: Double = 73
        var tora_b15_blok13: Double //РДР'
        var m_vzl_b16_blok13: Double
        var b17_blok13: Double // S'
        var k_vert_b18_blok13: Double
        var k_1000_b19_blok13: Double
        var s_blok12: Double
        var b20_blok13: Double
        var k_2200_b21_blok13: Double
        var b22_blok13: Double
        var k_okon_b23_blok13: Double
        izlom_t_blok13 = 30 - 0.00633333 * height_c2
        if height_c2 >= 2000 && t >= izlom_t_blok13 {
            s_blok12 = ((0.73 * height_c2 + 1030) - (0.39 * height_c2 + 290)) * (0.02 * t) + (0.39 * height_c2 + 290)
        } else if height_c2 < 2000 && height_c2 >= 1000 && t >= izlom_t_blok13 {
            s_blok12 = ((0.63 * height_c2 + 1230) - (0.34 * height_c2 + 390)) * (0.02 * t) + (0.34 * height_c2 + 390)
        } else if height_c2 < 1000 && t >= izlom_t_blok13 {
            s_blok12 = ((0.39 * height_c2 + 1470) - (0.22 * height_c2 + 510)) * (0.02 * t) + (0.22 * height_c2 + 510)
        } else if height_c2 < 1000 && t < izlom_t_blok13 {
            s_blok12 = ((0.27 * height_c2 + 1120) - (0.08 * height_c2 + 880)) * (0.01 * t + 0.5) + (0.08 * height_c2 + 880)
        } else if height_c2 >= 1000 && height_c2 < 2000 && t >= 0 && t < izlom_t_blok13 {
            s_blok12 = ((0.3 * height_c2 + 1100) - (0.3 * height_c2 + 875)) * (0.02 * t) + (0.3 * height_c2 + 875)
        } else if height_c2 >= 2000 && height_c2 < 3000 && t >= 0 && t < izlom_t_blok13 {
            s_blok12 = ((0.325 * height_c2 + 1050) - (0.325 * height_c2 + 825)) * (0.02 * t) + (0.325 * height_c2 + 825)
        } else if height_c2 >= 1000 && height_c2 < 2000 && t < 0 {
            s_blok12 = ((0.3 * height_c2 + 875) - (0.19 * height_c2 + 770)) * (0.02 * t + 1) + (0.19 * height_c2 + 770)
        } else /*if height_c2 >= 2000 && t < 0 */ {
            s_blok12 = ((0.325 * height_c2 + 825) - (0.425 * height_c2 + 300)) * (0.02 * t + 1) + (0.425 * height_c2 + 300)
        }
        // else if усли ложь - ???
        tora_b15_blok13 = (b4_blok12 - (0.820513 * b4_blok12 - 189.744)) * (0.0769231 * alfa_rud_b14_blok13 - 4.61538) + (0.820513 * b4_blok12 - 189.744)
        
        b17_blok13 = (1.75 * s_blok12 - 50)
        if (tora_b15_blok13 - s_blok12) / (b17_blok13 - s_blok12) > 1 {
           k_vert_b18_blok13 = 1
        } else {
            k_vert_b18_blok13 = (tora_b15_blok13 - s_blok12) / (b17_blok13 - s_blok12)
        }
        k_1000_b19_blok13 = (-0.291651 * pow(k_vert_b18_blok13, 2) + 1.29165 * k_vert_b18_blok13)
        b20_blok13 = k_1000_b19_blok13 * 30000 + 80000
        k_2200_b21_blok13 = (-0.530222 * pow(k_vert_b18_blok13, 2) + 1.53022 * k_vert_b18_blok13)
        b22_blok13 = k_2200_b21_blok13 * 30000 + 80000
        k_okon_b23_blok13 = (k_2200_b21_blok13 - k_1000_b19_blok13) * (0.000833333 * s_blok12 - 0.833333) + k_1000_b19_blok13
        m_vzl_b16_blok13 = k_okon_b23_blok13 * 30000 + 80000
        /*
        b1 - t
        b2 - height_c2
        b3 - izlom_t_blok13
        b12 - s_blok12
        b13 - b4_blok12
        b14 - alfa_rud_b14_blok13
        b15 - tora_b15_blok13
        b16 - m_vzl_b16_blok13
        b17 - b17_blok13
        b18 - k_vert_b18_blok13
        b19 - k_1000_b19_blok13
        b20 - b20_blok13
        b21 - k_2200_b21_blok13
        b22 - b22_blok13
        b23 - k_okon_b23_blok13
        */
        
        
        // БЛОК 14 Приведенная масса самолета в зависимости от взлетной массы и условий на аэродроме. ОБРАТНЫЙ РАСЧЕТ ФАКТ.
        var b8_blok14: Double
        var vspom_blok14: Double
        var vspom2_blok14: Double
        var m_priv_b10_blok14: Double
        if t<0 {
            b8_blok14 =  ((-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200) - (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)) * (0.02 * t + 1) + (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 2000 && height_c2 <= 3000 {
            vspom_blok14 = (18.5 * height_c2 + 104500) - (17.5 * height_c2 + 67500)
            vspom2_blok14 = 17.5 * height_c2 + 67500
            b8_blok14 = vspom_blok14 * (0.025 * t - 0.25) + vspom2_blok14
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 1000 && height_c2 <= 2000 {
            b8_blok14 = ((23 * height_c2 + 95500) - (15 * height_c2 + 79000)) * (0.030303 * t - 0.515152) + (15 * height_c2 + 79000)
        } else if t > (36 - 0.012 * height_c2) && height_c2 >= 0 && height_c2 <= 1000 {
            b8_blok14 = ((11.7 * height_c2 + 107000) - (17 * height_c2 + 82000)) * (0.0384615 * t - 0.923077) + (17 * height_c2 + 82000)
        } else {
            b8_blok14 = ((-0.0000009 * pow(height_c2, 3) + 0.0053 * pow(height_c2, 2) + 2.6 * height_c2 + 96800) - (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)) * 0.02 * t + (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)
        }
        if m_vlz_fakt > 90000 {
            m_priv_b10_blok14 = ((0.00000375 * pow(b8_blok14, 2) + 0.425 * b8_blok14 + 42000) - b8_blok14) * (0.00005 * m_vlz_fakt - 4.5) + b8_blok14
        } else {
            m_priv_b10_blok14 = ((0.000000118519 * pow(b8_blok14, 2) + 0.802519 * b8_blok14 - 2857.04) - b8_blok14) * (4.5 - 0.00005 * m_vlz_fakt) + b8_blok14
        }
        /*
        b1 - t
        b2 - height_c2
        b8 - b8_blok14
        b9 - m_vlz_fakt
        b10 - m_priv_b10_blok14
        */
        
        
        // БЛОК 15 Обратный расчет. ПРОДОЛЖЕННЫЙ  ВЗЛЕТ
        var m_priv_b4_blok15: Double
        var b1_blok15: Double
        var v1_vr_blok15: Double
        m_priv_b4_blok15 = m_priv_b10_blok14 / 1000
        if ((80.7143 * m_priv_b4_blok15 - 7440) - (-0.00168398 * pow(m_priv_b4_blok15, 4) + 0.701585 * pow(m_priv_b4_blok15, 3) - 108.508 * pow(m_priv_b4_blok15, 2) + 7452.96 * m_priv_b4_blok15 - 191285)) * (0.000588235 * asda_korr_b4 - 0.882353) + (-0.00168398 * pow(m_priv_b4_blok15, 4) + 0.701585 * pow(m_priv_b4_blok15, 3) - 108.508 * pow(m_priv_b4_blok15, 2) + 7452.96 * m_priv_b4_blok15 - 191285) < 1500 {
           b1_blok15 = 1500
        } else {
            b1_blok15 = ((80.7143 * m_priv_b4_blok15 - 7440) - (-0.00168398 * pow(m_priv_b4_blok15, 4) + 0.701585 * pow(m_priv_b4_blok15, 3) - 108.508 * pow(m_priv_b4_blok15, 2) + 7452.96 * m_priv_b4_blok15 - 191285)) * (0.000588235 * asda_korr_b4 - 0.882353) + (-0.00168398 * pow(m_priv_b4_blok15, 4) + 0.701585 * pow(m_priv_b4_blok15, 3) - 108.508 * pow(m_priv_b4_blok15, 2) + 7452.96 * m_priv_b4_blok15 - 191285)
        }
        if ((0.00022222 * asda_korr_b4 + 0.6067) - (-0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)) * (0.00000012302 * pow(b1_blok15, 2) - 0.0010766 * b1_blok15 + 2.3381) + (-0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553) > 1 {
           v1_vr_blok15 = 1
        } else {
           v1_vr_blok15 = ((0.00022222 * asda_korr_b4 + 0.6067) - (-0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)) * (0.00000012302 * pow(b1_blok15, 2) - 0.0010766 * b1_blok15 + 2.3381) + (-0.000000026626 * pow(asda_korr_b4, 2) + 0.00026641 * asda_korr_b4 + 0.3553)
        }
        /*
         b1 - b1_blok15
         b2 - asda_korr_b4
         b3 - v1_vr_blok15
         b4 - m_priv_b4_blok15
         */
        
        
        // БЛОК 16 V1
        var v1: Double
        if v_pst * v1_vr_blok15 < 185 {
            v1 = 185
        } else {
            v1 = v_pst * v1_vr_blok15
        }
        /*
         b1 - v_pst
         b2 - v1_vr_blok15
         b3 - v1
         */

        // БЛОК 17 Скорость начала уборки механизации на взлете V3 (закр.18; предкр.19) и скорость при полетной конфигурации V4
        var m_vzl_blok17: Double
        var v3: Double
        var v4: Double
        m_vzl_blok17 = m_vzl / 1000
        v3 = 1.8 * m_vzl_blok17 + 164.004
        v4 = 1.92 * m_vzl_blok17 + 181.3978
        /*
         b1 - m_vzl_blok17
         b2 - v3
         b3 - v4
         */
        
        
        // БЛОК 18 Приведенная масса самолета в зависимости от взлетной массы и условий на аэродроме. ОБРАТНЫЙ РАСЧЕТ  МАКС.
        var b3_blok18: Double
        var b4_blok18: Double
        var b5_blok18: Double
        var b6_blok18: Double
        var b7_blok18: Double
        var m_blok18: Double
        var fin_m_vzl_max: Double //максимально допустимая взлетная масса
        var m_priv_blok18: Double
        var masses = [Double] ()
        b3_blok18 = ((-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200) - (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)) * (0.02 * t + 1) + (0.000000283333 * pow(height_c2, 3) - 0.0008 * pow(height_c2, 2) + 10.7167 * height_c2 + 73400)
        b4_blok18 = ((-0.0000009 * pow(height_c2, 3) + 0.0053 * pow(height_c2, 2) + 2.6 * height_c2 + 96800) - (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)) * 0.02 * t + (-0.0000001 * pow(height_c2, 3) + 0.00155 * pow(height_c2, 2) + 6.95 * height_c2 + 86200)
        b5_blok18 = ((18.5 * height_c2 + 104500) - (17.5 * height_c2 + 67500)) * (0.025 * t - 0.25) + (17.5 * height_c2 + 67500)
        b6_blok18 = ((23 * height_c2 + 95500) - (15 * height_c2 + 79000)) * (0.030303 * t - 0.515152) + (15 * height_c2 + 79000)
        b7_blok18 = ((11.7 * height_c2 + 107000) - (17 * height_c2 + 82000)) * (0.0384615 * t - 0.923077) + (17 * height_c2 + 82000)
        if t<0 {
            m_blok18 = b3_blok18
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 2000 && height_c2 <= 3000 {
            m_blok18 = b5_blok18
        } else if t > (31 - 0.007 * height_c2) && height_c2 >= 1000 && height_c2 <= 2000 {
            m_blok18 = b6_blok18
        } else if t > (36 - 0.012 * height_c2) && height_c2 >= 0 && height_c2 <= 1000 {
            m_blok18 = b7_blok18
        } else {
            m_blok18 = b4_blok18
        }
        masses = [m_vzl_b10, m_b10_blok8, m_b9_blok9, m_vzl_b15_blok11, m_vzl_b16_blok13, m_max]
        fin_m_vzl_max = masses.min()!
        
        if fin_m_vzl_max > 90000 {
            m_priv_blok18 = ((0.00000375 * pow(m_blok18, 2) + 0.425 * m_blok18 + 42000) - m_blok18) * (0.00005 * fin_m_vzl_max - 4.5) + m_blok18
        } else {
            m_priv_blok18 = ((0.000000118519 * pow(m_blok18, 2) + 0.802519 * m_blok18 - 2857.04) - m_blok18) * (4.5 - 0.00005 * fin_m_vzl_max) + m_blok18
        }
        /*
         b1 - t
         b2 - height_c2
         b3 - b3_blok18
         b4 - b4_blok18
         b5 - b5_blok18
         b6 - b6_blok18
         b7 - b7_blok18
         b8 - m_blok18
         b9 - fin_m_vzl_max
         b10 - m_priv_blok18
         */
        
        
        // БЛОК 19 Взлетный режим работы двигателей в зависимости от приведенной массы
        var m_b1_blok19: Double
        var ogr_grad_2_4: Double
        var b4_blok19: Double
        var uchit_2_4: Double
        var vzl_rezh: Double
        var m_shrt_blok19: Double
        var k_vert_blok19: Double
        var k_goriz_blok19: Double
        var b10_blok19: Double
        var b11_blok19: Double
        if m_priv_blok18 >= 114000 {
            m_b1_blok19 = 114000
        } else {
            m_b1_blok19 = m_priv_blok18
        }
        if m_b1_blok19 <= 100000 {
            m_shrt_blok19 = m_b1_blok19 - 14000
        } else {
            m_shrt_blok19 = 1.2375 * m_b1_blok19 - 37750
        }
        k_vert_blok19 = ((m_b1_blok19 - m_priv_b10_blok14) / (m_b1_blok19 - m_shrt_blok19))
        k_goriz_blok19 = (-0.0336392 * pow(k_vert_blok19, 2) + 1.03364 * k_vert_blok19 + 0.00000000000000110502)
        b10_blok19 = (73 - 13 * k_vert_blok19)
        b11_blok19 = (73-13 * k_goriz_blok19)
        b4_blok19 = b10_blok19 - (b10_blok19 - b11_blok19) * 10
        ogr_grad_2_4 = (0.000722222 * m_priv_b10_blok14 - 9.26111)
        if b4_blok19 < ogr_grad_2_4 {
            uchit_2_4 = ogr_grad_2_4
        } else {
            uchit_2_4 = b4_blok19
        }
        if height_c2 > 2000 || kBR < 0.45 || rwCondition == 2 || rwCondition == 3 {
            vzl_rezh = 73
        } else if  m_priv_b10_blok14 < 95000 || (m_b1_blok19 - m_priv_b10_blok14) > 21700 || uchit_2_4 <= 60 {
            vzl_rezh = 60
        } else if uchit_2_4 <= 66 && uchit_2_4 > 60 {
            vzl_rezh = 66
        } else if uchit_2_4 > 66 {
            vzl_rezh = 73
        } else {
            vzl_rezh = 999999 // т.е. ошибка
        }
        /*
         b1 - m_b1_blok19
         b2 - m_priv_b10_blok14
         b3 - ogr_grad_2_4
         b4 - b4_blok19
         b5 - uchit_2_4
         b6 - vzl_rezh
         b7 - m_shrt_blok19
         b8 - k_vert_blok19
         b9 - k_goriz_blok19
         b10 - b10_blok19
         b11 - b11_blok19
         */
        
        
        // БЛОК 20 Распологаемый для взлета режим работы двигателей ПС-90А (n2,%) в зависимости от Альфа РУД и температуры наружного воздуха
        var n2: Double
        var p_aer_blok20: Double
        var b3_blok20: Double
        var b4_blok20: Double
        var b5_blok20: Double
        var b6_blok20: Double
        var b7_blok20: Double
        var b8_blok20: Double
        var b9_blok20: Double
        var b10_blok20: Double
        var b11_blok20: Double
        var b12_blok20: Double
        var b13_blok20: Double
        var b14_blok20: Double
        var b15_blok20: Double
        var b16_blok20: Double
        var b17_blok20: Double
        var c3_blok20: Double
        var c4_blok20: Double
        var c5_blok20: Double
        var c6_blok20: Double
        var c7_blok20: Double
        var c8_blok20: Double
        var c9_blok20: Double
        var c10_blok20: Double
        var c11_blok20: Double
        var c12_blok20: Double
        var c13_blok20: Double
        var c14_blok20: Double
        var c15_blok20: Double
        var c16_blok20: Double
        var c17_blok20: Double
        var d3_blok20: Double
        var d8_blok20: Double
        var d13_blok20: Double
        var error: String
        if mm_rt_st > 760 {
            p_aer_blok20 = 760
        } else {
            p_aer_blok20 = mm_rt_st
        }
        b3_blok20 = -1.6456 * pow(10,(-4)) * pow(t, 2) + 0.1707 * t + 92.0308
        b4_blok20 = -3.2967 * pow(10, (-5)) * pow(t, 2) + 0.1663 * t + 92.3621
        b5_blok20 = -5.4945 * pow(10, (-6)) * pow(t, 2) + 0.1677 * t + 92.7569
        b6_blok20 = 2.1978 * pow(10, (-5)) * pow(t, 2) + 0.1678 * t + 93.0407
        b7_blok20 = -4.3956 * pow(10, (-5)) * pow(t, 2) + 0.167 * t + 93.3231
        b8_blok20 = -1.4846 * pow(10, (-4)) * pow(t, 2) + 0.1644 * t + 91.7824
        b9_blok20 = -9.1733 * pow(10, (-5)) * pow(t, 2) + 0.1628 * t + 91.7939
        b10_blok20 = 0.1649 * t + 92.1084
        b11_blok20 = 2.0776 * pow(10, (-10)) * pow(t, 2) + 0.165 * t + 92.3978
        b12_blok20 = 0.1654 * t + 92.6577
        b13_blok20 = -1.3305 * pow(10, (-4)) * pow(t, 2) + 0.1615 * t + 90.5267
        b14_blok20 = -7.7732 * pow(10, (-5)) * pow(t, 2) + 0.1604 * t + 90.5299
        b15_blok20 = 2.618 * pow(10, (-5)) * pow(t, 2) + 0.1625 * t + 90.8497
        b16_blok20 = -1.3736 * pow(10, (-5)) * pow(t, 2) + 0.1628 * t + 91.1496
        b17_blok20 = 2.5974 * pow(10, (-5)) * t + 0.1642 * t + 91.4248
        if b3_blok20 > 97.3 {
            c3_blok20 = 97.3
        } else {
            c3_blok20 = b3_blok20
        }
        if b4_blok20 > 97.2 {
            c4_blok20 = 97.2
        } else {
            c4_blok20 = b4_blok20
        }
        if b5_blok20 > 96.8 {
            c5_blok20 = 96.8
        } else {
            c5_blok20 = b5_blok20
        }
        if b6_blok20 > 96.5 {
            c6_blok20 = 96.5
        } else {
            c6_blok20 = b6_blok20
        }
        if b7_blok20 > 96.1 {
            c7_blok20 = 96.1
        } else {
            c7_blok20 = b7_blok20
        }
        if b8_blok20 > 96.6 {
            c8_blok20 = 96.6
        } else {
            c8_blok20 = b8_blok20
        }
        if b9_blok20 > 96.5 {
            c9_blok20 = 96.5
        } else {
            c9_blok20 = b9_blok20
        }
        if b10_blok20 > 96.2 {
            c10_blok20 = 96.2
        } else {
            c10_blok20 = b10_blok20
        }
        if b11_blok20 > 95.9 {
            c11_blok20 = 95.9
        } else {
            c11_blok20 = b11_blok20
        }
        if b12_blok20 > 95.6 {
            c12_blok20 = 95.6
        } else {
            c12_blok20 = b12_blok20
        }
        if b13_blok20 > 95.2 {
            c13_blok20 = 95.2
        } else {
            c13_blok20 = b13_blok20
        }
        if b14_blok20 > 95.2 {
            c14_blok20 = 95.2
        } else {
            c14_blok20 = b14_blok20
        }
        if b15_blok20 > 94.9 {
            c15_blok20 = 94.9
        } else {
            c15_blok20 = b15_blok20
        }
        if b16_blok20 > 94.6 {
            c16_blok20 = 94.6
        } else {
            c16_blok20 = b16_blok20
        }
        if b17_blok20 > 94.3 {
            c17_blok20 = 94.3
        } else {
            c17_blok20 = b17_blok20
        }
        if p_aer_blok20 > 760 {
            d3_blok20 = 84
        } else if p_aer_blok20 <= 760 && p_aer_blok20 >= 730 {
            d3_blok20 = c3_blok20 + (c4_blok20 - c3_blok20) * (-0.0333 * p_aer_blok20 + 25.331)
        } else if p_aer_blok20 < 730 && p_aer_blok20 >= 674.2 {
            d3_blok20 = c4_blok20 + (c5_blok20 - c4_blok20) * (-0.0179 * p_aer_blok20 + 13.0824)
        } else if p_aer_blok20 < 674.2 && p_aer_blok20 >= 634.25 {
            d3_blok20 = c5_blok20 + (c6_blok20 - c5_blok20) * (-0.025 * p_aer_blok20 + 16.876)
        } else if p_aer_blok20 < 634.25 && p_aer_blok20 >= 596.31 {
            d3_blok20 = c6_blok20 + (c7_blok20 - c6_blok20) * (-0.0264 * p_aer_blok20 + 16.7171)
        } else {
            d3_blok20 = 999999 // т.е. ошибка
        }
        if p_aer_blok20 > 760 {
            d8_blok20 = 84
        } else if p_aer_blok20 <= 760 && p_aer_blok20 >= 730 {
            d8_blok20 = c8_blok20 + (c9_blok20 - c8_blok20) * (-0.0333 * p_aer_blok20 + 25.331)
        } else if p_aer_blok20 < 730 && p_aer_blok20 >= 674.2 {
            d8_blok20 = c9_blok20 + (c10_blok20 - c9_blok20) * (-0.0179 * p_aer_blok20 + 13.0824)
        } else if p_aer_blok20 < 674.2 && p_aer_blok20 >= 634.25 {
            d8_blok20 = c10_blok20 + (c11_blok20 - c10_blok20) * (-0.025 * p_aer_blok20 + 16.876)
        } else if p_aer_blok20 < 634.25 && p_aer_blok20 >= 596.31 {
            d8_blok20 = c11_blok20 + (c12_blok20 - c11_blok20) * (-0.0264 * p_aer_blok20 + 16.7171)
        } else {
            d8_blok20 = 999999 // т.е. ошибка
        }
        if p_aer_blok20 > 760 {
            d13_blok20 = 83
        } else if p_aer_blok20 <= 760 && p_aer_blok20 >= 730 {
            d13_blok20 = c13_blok20 + (c14_blok20 - c13_blok20) * (-0.0333 * p_aer_blok20 + 25.331)
        } else if p_aer_blok20 < 730 && p_aer_blok20 >= 674.2 {
            d13_blok20 = c14_blok20 + (c15_blok20 - c14_blok20) * (-0.0179 * p_aer_blok20 + 13.0824)
        } else if p_aer_blok20 < 674.2 && p_aer_blok20 >= 634.25 {
            d13_blok20 = c15_blok20 + (c16_blok20 - c15_blok20) * (-0.025 * p_aer_blok20 + 16.876)
        } else if p_aer_blok20 < 634.25 && p_aer_blok20 >= 596.31 {
            d13_blok20 = c16_blok20 + (c17_blok20 - c16_blok20) * (-0.0264 * p_aer_blok20 + 16.7171)
        } else {
            d13_blok20 = 999999 // т.е. ошибка
        }
        if vzl_rezh == 60 {
            n2 = d13_blok20
        } else if vzl_rezh == 66 {
            n2 = d8_blok20
        } else {
            n2 = d3_blok20
        }
        /*
         b1 - t
         c2 - n2
         d2 - p_aer_blok20
         b3 - b3_blok20
         b4 - b4_blok20
         b5 - b5_blok20
         b6 - b6_blok20
         b7 - b7_blok20
         b8 - b8_blok20
         b9 - b9_blok20
         b10 - b10_blok20
         b11 - b11_blok20
         b12 - b12_blok20
         b13 - b13_blok20
         b14 - b14_blok20
         b15 - b15_blok20
         b16 - b16_blok20
         b17 - b17_blok20
         c3 - c3_blok20
         c4 - c4_blok20
         c5 - c5_blok20
         c6 - c6_blok20
         c7 - c7_blok20
         c8 - c8_blok20
         c9 - c9_blok20
         c10 - c10_blok20
         c11 - c11_blok20
         c12 - c12_blok20
         c13 - c13_blok20
         c14 - c14_blok20
         c15 - c15_blok20
         c16 - c16_blok20
         c17 - c17_blok20
         d3 - d3_blok20
         d8 - d8_blok20
         d13 - d13_blok20
         */
        
        
        // БЛОК 21 Градиенты набора высоты на взлете при скорости V2
        var b4_blok21: Double
        var b5_blok21: Double
        var b6_blok21: Double
        var b7_blok21: Double
        var b8_blok21: Double
        var b9_blok21: Double
        var b10_blok21: Double
        var line_otsch: Double
        var left_from_line: Double
        var right_from_line: Double
        var grad_blok21: Double
        b4_blok21 = ((0.00589 * t + 8.183) - 7.5) * (1 - 0.001 * height_c2) + 7.5
        b5_blok21 = 30 - 0.0062 * height_c2
        b6_blok21 = ((12.13 - 0.12568 * t) - (11.432 - 0.16578 * t)) * (1 - 0.001 * height_c2) + (11.432 - 0.16578 * t)
        b7_blok21 = (7.5 - 4.3) * (1.5 - 0.0005 * height_c2) + 4.3
        b8_blok21 = 30.76 - 0.0069598 * height_c2
        b9_blok21 = ((11.432 - 0.16578 * t) - (8.3767 - 0.14569 * t)) * (2 - 0.001 * height_c2) + (8.3767 - 0.14569 * t)
        b10_blok21 = ((8.3767 - 0.14569 * t) - (5.5017 - 0.12163 * t)) * (3 - 0.001 * height_c2) + (5.5017 - 0.12163 * t)
        if height_c2 <= 1000 && t <= b5_blok21 {
            line_otsch = b4_blok21
        } else if height_c2 <= 1000 && t > b5_blok21 {
            line_otsch = b6_blok21
        } else if height_c2 > 1000 && t <= b8_blok21 {
            line_otsch = b7_blok21
        } else if height_c2 > 1000 && height_c2 <= 2000 && t > b8_blok21 {
            line_otsch = b9_blok21
        } else if height_c2 > 2000 && t > b8_blok21 {
            line_otsch = b10_blok21
        } else {
            line_otsch = 999999 // т.е. ошибка
        }
        left_from_line = ((1.8463 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 5.6687 * pow(10, (-4)) * m_vlz_fakt + 40.5325) - (5.866 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 1.1099 * pow(10, (-3)) * m_vlz_fakt + 54.248)) * (0.25 * line_otsch - 0.75) + (5.866 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 1.1099 * pow(10, (-3)) * m_vlz_fakt + 54.248)
        right_from_line = ((1.976 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 5.554 * pow(10,(-4)) * m_vlz_fakt + 40.76) - (1.6238 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 4.5031 * pow(10,(-4)) * m_vlz_fakt + 30.605)) * (0.24999 * line_otsch - 1.249) + (1.6238 * pow(10, (-9)) * pow(m_vlz_fakt, 2) - 4.5031 * pow(10, (-4)) * m_vlz_fakt + 30.605)
        if m_vlz_fakt < 80000 {
            grad_blok21 = left_from_line
        } else {
            grad_blok21 = right_from_line
        }
        /*
         b1 - t
         b2 - height_c2
         b3 - m_vlz_fakt
         b4 - b4_blok21
         b5 - b5_blok21
         b6 - b6_blok21
         b7 - b7_blok21
         b8 - b8_blok21
         b9 - b9_blok21
         b10 - b10_blok21
         b11 - line_otsch
         b12 - left_from_line
         b13 - right_from_line
         b14 - grad_blok21
         */
        
        
        // БЛОК 22 Градиент ---> Vy
        var v_blok22: Double
        var v_y: Double
        v_blok22 = v_2 / 3.6
        v_y = v_blok22 * grad_blok21 / 100
        /*
         b1 - v_2
         b2 - grad_blok21
         b3 - v_blok22
         b4 - v_y
         */
        
        
        // БЛОК 23 РИС 2.2.0
        var crosswind_max: Double
        if rwCondition == 1 {
            crosswind_max = 33.3333 * kBR - 5
        } else {
            crosswind_max = 5
        }
        /*
         b1 - kBR
         b2 - crosswind_max
         */

        
        
        //Округление выходных значений
        crosswind_max = (crosswind_max*10).rounded()/10
        crosswind = (crosswind*10).rounded() / 10
        headwind = (headwind*10).rounded() / 10
        qfe = (qfe*10).rounded() / 10
        mm_rt_st = (mm_rt_st*10).rounded() / 10
        height_c2 = (height_c2*10).rounded() / 10
        fin_m_vzl_max = (fin_m_vzl_max*10).rounded() / 10
        vzl_rezh = (vzl_rezh*10).rounded() / 10
        n2 = (n2*10).rounded() / 10
        v1 = (v1*10).rounded() / 10
        v_pst = (v_pst*10).rounded() / 10
        v_2 = (v_2*10).rounded() / 10
        grad_blok21 = (grad_blok21*10).rounded() / 10
        v_y = (v_y*10).rounded() / 10
        v3 = (v3*10).rounded() / 10
        v4 = (v4*10).rounded() / 10


        // ВЫВОД РЕЗУЛЬТАТОВ
        calculationsresult.text = " Crosswind MAX = \(Double(crosswind_max)) , Crosswind ACTUAL = \(Double(crosswind)) \n HEADWIND = \(Double(headwind)) \n \n QFE = \(Double(qfe)) / \(Double(mm_rt_st)) мм.рт.ст.    Elev = \(Double(height_c2)) \n \n MAX TAKEOFF MASS = \(Double(fin_m_vzl_max)) \n \n Взлетный режим работы двигателя: \(Double(vzl_rezh)), n2 = \(Double(n2)) % \n \n Скорость принятия решения V1 = \(Double(v1)) \n Cкорость подъема передней стойки шасси VR = \(Double(v_pst)) \n Скорость на взлете V2 = \(Double(v_2)) Град на одном дв. \(Double(grad_blok21)) - \(Double(v_y)) м/с \n Скорость начала уборки механизации на взлете V3 = \(Double(v3)) \n Cкорость при полетной конфигурации V4 = \(Double(v4))"
     
        
        /*calculationsresult.text = " b1 = \(Double(t)), b2 = \(Double(height_c2)), b3 = \(Double(izlom_t)), b11 = \(Double(s_blok_10)), \n b12 = \(Double(toda_b4_blok10)), b13 = \(Double(alfa_rud_b13_blok11)), b14 = \(Double(toda_b14_blok_11)), b15 = \(Double(m_vzl_b15_blok11)), b16 = \(Double(s_b16_blok11)),  \n b17 = \(Double(k_vert_b17_blok11)) b18 = \(Double(k_1000_b18_blok11)) b19 = \(Double(b19_blok11)) b20 = \(Double(k_2000_b20_blok11)) \n b20 = \(Double(k_2000_b20_blok11)) b21 = \(Double(b21_blok11)) b20 = \(Double(k_2000_b20_blok11)) b22 = \(Double(k_okon_b22_blok11)) b23 = \(Double(b23_blok11)) b24 = \(Double(b24_blok11))" */
        /* b1 - t
         b2 - height_c2
         b3 - izlom_t
         b11 - s_blok_10
         b12 - toda_b4_blok10
         b13 - alfa_rud_b13_blok11
         b14 - toda_b14_blok_11
         b15 - m_vzl_b15_blok11
         b16 - s_b16_blok11
         b17 - k_vert_b17_blok11
         b18 - k_1000_b18_blok11
         b19 - b19_blok11
         b20 - k_2000_b20_blok11
         b21 - b21_blok11
         b22 - k_okon_b22_blok11
         b23 - b23_blok11
         b24 - b24_blok11 */
 


        
    }

    
   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

