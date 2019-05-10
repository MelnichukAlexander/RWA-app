//
//  SecondViewController.swift
//  RWA App
//
//  Created by Александр on 08.04.2019.
//  Copyright © 2019 Alexander Melnichuk. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var ldaTextField: UITextField!
    @IBOutlet weak var elevlandTextField: UITextField!
    @IBOutlet weak var slopelandTextField: UITextField!
    @IBOutlet weak var hdglandTextField: UITextField!
    
    @IBOutlet weak var rwcondlandSegmented: UISegmentedControl!
    
    @IBOutlet weak var ksceplandTextField: UITextField!
    @IBOutlet weak var oatlandTextField: UITextField!
    @IBOutlet weak var qnhTextField: UITextField!
    @IBOutlet weak var windspeedlandTextField: UITextField!
    @IBOutlet weak var winddirlandTextField: UITextField!
    @IBOutlet weak var masslandTextField: UITextField!
    
    
    @IBOutlet weak var calclandButton: UIButton!
    @IBOutlet weak var labelTest: UILabel!
    
    
    //ВЫПАДАЮЩИЙ СПИСОК
    
    @IBAction func acsellandTapped(_ sender: UIButton) {
        
        let aircraftlist = UIAlertController(title: "Выберите ВС", message:nil, preferredStyle: .actionSheet)
        
        let aircraftname1: String = "Ту-204-100В"
        let aircraftname2: String = "МС-21"
        let aircraftname3: String = "Sukhoi Superjet 100"
        let aircraftname4: String = "Ил-96-300"
        let aircraftname5: String = "Як-42Д"
        
        
        let aircraftItem1 = UIAlertAction(title: aircraftname1, style: .default, handler: {action in
            sender.setTitle(aircraftname1, for: .normal)
            sender.setTitleColor(.green, for: .normal)
            self.calclandButton.isHidden = false
        })
        
        let aircraftItem2 = UIAlertAction(title: aircraftname2, style: .default, handler: {action in
            let aircraftalert = UIAlertController(title: "Загрузите данные по ВС", message: "Загрузите данные по ВС для выполнения расчетов", preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            aircraftalert.addAction(okbutton)
            self.present(aircraftalert, animated: true, completion: nil)
            
            sender.setTitle(aircraftname2, for: .normal)
            sender.setTitleColor(.red, for: .normal)
            self.calclandButton.isHidden = true
            self.labelTest.text = ""
        })
        
        let aircraftItem3 = UIAlertAction(title: aircraftname3, style: .default, handler: {action in
            let aircraftalert = UIAlertController(title: "Загрузите данные по ВС", message: "Загрузите данные по ВС для выполнения расчетов", preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            aircraftalert.addAction(okbutton)
            self.present(aircraftalert, animated: true, completion: nil)
            
            sender.setTitle(aircraftname3, for: .normal)
            sender.setTitleColor(.red, for: .normal)
            self.calclandButton.isHidden = true
            self.labelTest.text = ""
        })
        
        let aircraftItem4 = UIAlertAction(title: aircraftname4, style: .default, handler: {action in
            let aircraftalert = UIAlertController(title: "Загрузите данные по ВС", message: "Загрузите данные по ВС для выполнения расчетов", preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            aircraftalert.addAction(okbutton)
            self.present(aircraftalert, animated: true, completion: nil)
            
            sender.setTitle(aircraftname4, for: .normal)
            sender.setTitleColor(.red, for: .normal)
            self.calclandButton.isHidden = true
            self.labelTest.text = ""
        })
        
        let aircraftItem5 = UIAlertAction(title: aircraftname5, style: .default, handler: {action in
            let aircraftalert = UIAlertController(title: "Загрузите данные по ВС", message: "Загрузите данные по ВС для выполнения расчетов", preferredStyle: .alert)
            let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
            aircraftalert.addAction(okbutton)
            self.present(aircraftalert, animated: true, completion: nil)
            
            sender.setTitle(aircraftname5, for: .normal)
            sender.setTitleColor(.red, for: .normal)
            self.calclandButton.isHidden = true
            self.labelTest.text = ""
        })
        
        aircraftlist.addAction(aircraftItem1)
        aircraftlist.addAction(aircraftItem2)
        aircraftlist.addAction(aircraftItem3)
        aircraftlist.addAction(aircraftItem4)
        aircraftlist.addAction(aircraftItem5)
        
        if let ppc = aircraftlist.popoverPresentationController {
            ppc.sourceView = sender
            ppc.sourceRect = sender.bounds
        }
        
        present(aircraftlist, animated: true, completion: nil)
        
    }
    
    //ЗАГРУЗКА ПОГОДЫ (METAR)
    @IBAction func metarTapped(_ sender: UIButton) {
        let metaralert = UIAlertController(title: "Предупреждение", message: "Не подключен источник данных. Введите инфомацию о погоде вручную", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        metaralert.addAction(okbutton)
        self.present(metaralert, animated: true, completion: nil)
    }
    
    
    
    //РАСЧЕТ ПАРАМЕТРОВ ПОСАДКИ
    @IBAction func landingTapped(_ sender: UIButton) {
        
        //данные по аэродрому
        var brit_l: Bool = true
        var lda: Double = Double(ldaTextField.text!)!
        var slope_l: Double = Double(slopelandTextField.text!)!
        var hdg_l: Double = Double(hdglandTextField.text!)!
        var elev_l: Double = Double(elevlandTextField.text!)!
        
        //данные по ВС
        var m_land_max: Double = 88000
        
        //задаваемые переменные
        var t_land: Double = Double(oatlandTextField.text!)!
        var qnh_land: Double = Double(qnhTextField.text!)!
        var k_br_l: Double = Double(ksceplandTextField.text!)!
        var land_weight: Double = Double(masslandTextField.text!)!
        var wind_dir_l: Double = Double(winddirlandTextField.text!)!
        var wind_speed_l: Double = Double(windspeedlandTextField.text!)!
        var rw_cond_l: Double = 0
        if rwcondlandSegmented.selectedSegmentIndex == 0 {
            rw_cond_l = 1
        } else if rwcondlandSegmented.selectedSegmentIndex == 1 {
            rw_cond_l = 2
        } else if rwcondlandSegmented.selectedSegmentIndex == 2 {
            rw_cond_l = 3
        }
        var kren: Double = 0

        
        //БЛОК раскладка ветра
        var headwind_l, crosswind_l, sub_angle_l, sub_angle_rad_l: Double
        let pi = 3.14159
        sub_angle_l = wind_dir_l - hdg_l
        sub_angle_rad_l = sub_angle_l *  pi / 180
        crosswind_l = sin(sub_angle_rad_l) * wind_speed_l
        headwind_l = cos(sub_angle_rad_l) * wind_speed_l
        
        // БЛОК давление на аэродроме
        var hPa_l, qfe_land: Double
        hPa_l = -4.6708 * pow(10,(-7)) * pow(elev_l, 2) + 0.0363 * elev_l + 0.1842
        if brit_l == true {
            qfe_land = qnh_land - hPa_l
        } else {
            qfe_land = qnh_land - hPa_l * 3.2808
        }
        
        //БЛОК 1 (гПа ---> мм.рт.ст-1)
        var mm_rt_st_land: Double
        var vysota_land: Double
        mm_rt_st_land = qfe_land * 0.75
        vysota_land = 0.0078727 * pow(mm_rt_st_land, 2) - 22.9056 * mm_rt_st_land + 12861.4077
        /*
         a2 - qfe_land
         b2 - mm_rt_st_land
         c2 - vysota_land
         */
        
        
        //БЛОК 2 (Посадочная масса, ограниченная нормируемым градиентом набора высоты с одним отказавшим двигателем)
        var b3_blok2_l: Double
        var b4_blok2_l: Double
        var b5_blok2_l: Double
        var b6_blok2_l: Double
        var b7_blok2_l: Double
        var b8_blok2_l: Double
        var b9_blok2_l: Double
        var m_grad_l: Double
        b3_blok2_l = ((98839 - 13.7328 * vysota_land) - (93129.3 - 13.6054 * vysota_land)) * (9 - 0.2 * t_land) + (93129.3 - 13.6054 * vysota_land)
        b4_blok2_l = ((105200 - 14.6667 * vysota_land) - (98839 - 13.7328 * vysota_land)) * (8 - 0.2 * t_land) + (98839 - 13.7328 * vysota_land)
        b5_blok2_l = ((109742 - 14.1935 * vysota_land) - (105200 - 14.6667 * vysota_land)) * (7 - 0.2 * t_land) + (105200 - 14.6667 * vysota_land)
        b6_blok2_l = ((112654 - 13.3253 * vysota_land) - (109742 - 14.1935 * vysota_land)) * (6 - 0.2 * t_land) + (109742 - 14.1935 * vysota_land)
        b7_blok2_l = ((117515 - 13.4146 * vysota_land) - (112654 - 13.3253 * vysota_land)) * (5 - 0.2 * t_land) + (112654 - 13.3253 * vysota_land)
        b8_blok2_l = ((120479 - 13.1422 * vysota_land) - (117515 - 13.4146 * vysota_land)) * (4 - 0.2 * t_land) + (117515 - 13.4146 * vysota_land)
        b9_blok2_l = ((111695 - 8.66483 * vysota_land) - (120479 - 13.1422 * vysota_land)) * (3 - 0.2 * t_land) + (120479 - 13.1422 * vysota_land)
        if t_land >= 40 {
            m_grad_l = b3_blok2_l
        } else if t_land < 40 && t_land >= 35 {
            m_grad_l = b4_blok2_l
        } else if t_land < 35 && t_land >= 30 {
            m_grad_l = b5_blok2_l
        } else if t_land < 30 && t_land >= 25 {
            m_grad_l = b6_blok2_l
        } else if t_land < 25 && t_land >= 20 {
            m_grad_l = b7_blok2_l
        } else if t_land < 20 && t_land >= 15 {
            m_grad_l = b8_blok2_l
        } else if t_land < 15 && t_land >= 10 {
            m_grad_l = b9_blok2_l
        } else {
            m_grad_l = 88000
        }
        /*
         b1 - t_land
         b2 - vysota_land
         b3 - b3_blok2_l
         b4 - b4_blok2_l
         b5 - b5_blok2_l
         b6 - b6_blok2_l
         b7 - b7_blok2_l
         b8 - b8_blok2_l
         b9 - b9_blok2_l
         b10 - m_grad_l
         */
        
        
         //БЛОК 3 (LDA)
        var lda_blok3_l: Double
        if brit_l {
            lda_blok3_l = lda / 3.2808
        } else {
            lda_blok3_l = lda
        }
        
        
        //БЛОК 4 (Располагаемая длина ВПП с учетом ее состояния на посадке)
        var b3_blok4_l: Bool
        var b4_blok4_l: Double
        var dlina_vpp_blok4: Double
        var k_br_l_blok4: Double
        
        if rw_cond_l == 2 || rw_cond_l == 3 {
            b3_blok4_l = true
        } else {
            b3_blok4_l = false
        }
        if b3_blok4_l == true {
            b4_blok4_l = lda_blok3_l * 0.73333333333
        } else {
            b4_blok4_l = lda_blok3_l
        }
        if k_br_l >= 0.57 {
            k_br_l_blok4 = 0.57
        } else {
            k_br_l_blok4 = k_br_l
        }
        if b3_blok4_l {
            dlina_vpp_blok4 = b4_blok4_l
        } else {
            dlina_vpp_blok4 = ((0.6833 * b4_blok4_l - 4.9995) - b4_blok4_l) * (2.11111 - 3.7037 * k_br_l_blok4) + b4_blok4_l
        }
        /*
         b2 - lda_blok3_l
         b3 - b3_blok4_l
         b4 - b4_blok4_l
         b5 - k_br_l_blok4
         b6 - dlina_vpp_blok4
         */
        
        
        //БЛОК 5 (Скорректированная располагаемая посадочная дистанция)
        var a4_blok5_l: Double
        var b4_blok5_l: Double
        var rpd_ap_osn: Double
        var rpd_ap_zap: Double
        if dlina_vpp_blok4 > 2600 && slope_l < 0 {
            a4_blok5_l = ((0.9 * dlina_vpp_blok4 + 100) - dlina_vpp_blok4) * (-0.5 * slope_l) + dlina_vpp_blok4
        } else if dlina_vpp_blok4 <= 2800 {
            a4_blok5_l = ((1.0729 * dlina_vpp_blok4 - 29.2381) - dlina_vpp_blok4) * (0.5 * slope_l) + dlina_vpp_blok4
        } else if dlina_vpp_blok4 > 2800 {
            a4_blok5_l = ((dlina_vpp_blok4 + 200) - dlina_vpp_blok4) * (0.5 * slope_l) + dlina_vpp_blok4
        } else {
            a4_blok5_l = 777777 //ошибка
        }
        if a4_blok5_l <= 3000 && headwind_l < 0 {
            b4_blok5_l = ((a4_blok5_l - 400) - a4_blok5_l) * (-0.2 * headwind_l) + a4_blok5_l
        } else if headwind_l > 0 {
            b4_blok5_l = ((1.0556 * a4_blok5_l + 440.0142) - a4_blok5_l) * (0.05 * headwind_l) + a4_blok5_l
        } else {
            b4_blok5_l = ((0.77 * a4_blok5_l + 290.0116) - a4_blok5_l) * (-0.2 * headwind_l) + a4_blok5_l
        }
        rpd_ap_osn = b4_blok5_l
        rpd_ap_zap = 1.15 * b4_blok5_l + 30.0023
        /*
         a2 - dlina_vpp_blok4
         a3 - slope_l
         a4 - a4_blok5_l
         b2 - a4_blok5_l
         b3 - headwind_l
         b4 - b4_blok5_l
         c4 - rpd_ap_osn
         d4 - rpd_ap_zap
         */

        
        //БЛОК 6 (Потребная посадочная дистанция от ФАКТИЧЕСКОЙ посадочной массы)
        var d2_blok6_l, d3_blok6_l, d4_blok6_l, d5_blok6_l, d6_blok6_l, d7_blok6_l, d8_blok6_l, d9_blok6_l, d10_blok6_l, d11_blok6_l, d12_blok6_l, d13_blok6_l, d14_blok6_l, d15_blok6_l, d16_blok6_l, d17_blok6_l, d18_blok6_l, d19_blok6_l, d20_blok6_l, d21_blok6_l, d22_blok6_l: Double
        var b3_blok6_l, b4_blok6_l, b5_blok6_l, b6_blok6_l, b7_blok6_l, b8_blok6_l, b10_blok6_l, potr_pos_dist_ot_m, b13_blok6_l, b14_blok6_l, b15_blok6_l, b16_blok6_l, b18_blok6_l, b19_blok6_l, b20_blok6_l, b21_blok6_l: Double
        
        d2_blok6_l = 0.01 * pow(t_land, 2) + 3.5 * t_land + 1850
        d3_blok6_l = 0.0125 * pow(t_land, 2) + 3.9 * t_land + 1996
        d4_blok6_l = 0.0075 * pow(t_land, 2) + 4.05 * t_land + 2200
        d5_blok6_l = 3.8 * t_land + 2400
        d6_blok6_l = 0.0371111 * pow(t_land, 2) + 4.50778 * t_land + 1850
        d7_blok6_l = 0.0764897 * pow(t_land, 2) + 3.82021 * t_land + 1996
        d8_blok6_l = 0.0488975 * pow(t_land, 2) + 4.72205 * t_land + 2200
        d9_blok6_l = 6.45161 * t_land + 2400
        d10_blok6_l = 0.001 * vysota_land
        d11_blok6_l = 0.001 * vysota_land - 1
        d12_blok6_l = 0.001 * vysota_land - 2
        d13_blok6_l = 0.00000017 * pow(land_weight, 2) - 0.0158 * land_weight + 1976
        d14_blok6_l = 0.00000023 * pow(land_weight, 2) - 0.0222 * land_weight + 2304
        d15_blok6_l = 0.000000255 * pow(land_weight, 2) - 0.02305 * land_weight + 2412
        d16_blok6_l = 0.00000039 * pow(land_weight, 2) - 0.0385 * land_weight + 2984
        d17_blok6_l = 0.00000028 * pow(land_weight, 2) - 0.02 * land_weight + 2408
        d18_blok6_l = 0.000000319444 * pow(land_weight, 2) - 0.0336944 * land_weight + 2451.11
        d19_blok6_l = 0.000000444444 * pow(land_weight, 2) - 0.0546111 * land_weight + 3524.44
        d20_blok6_l = 0.000000972222 * pow(land_weight, 2) - 0.133556 * land_weight + 6662.22
        d21_blok6_l = 0.000000777778 * pow(land_weight, 2) - 0.0871111 * land_weight + 4391.11
        d22_blok6_l = 0.00000152 * pow(land_weight, 2) - 0.202 * land_weight + 9032
        b3_blok6_l = (d3_blok6_l - d2_blok6_l) * d10_blok6_l + d2_blok6_l
        b4_blok6_l = (d4_blok6_l - d3_blok6_l) * d11_blok6_l + d3_blok6_l
        b5_blok6_l = (d5_blok6_l - d4_blok6_l) * d12_blok6_l + d4_blok6_l
        b6_blok6_l = (d7_blok6_l - d6_blok6_l) * d10_blok6_l + d6_blok6_l
        b7_blok6_l = (d8_blok6_l - d7_blok6_l) * d11_blok6_l + d7_blok6_l
        b8_blok6_l = (d9_blok6_l - d8_blok6_l) * d12_blok6_l + d8_blok6_l
        
        if t_land <= 0 && vysota_land <= 1000 {
            b10_blok6_l = b3_blok6_l
        } else if t_land <= 0 && vysota_land > 1000 && vysota_land < 2000 {
            b10_blok6_l = b4_blok6_l
        } else if t_land <= 0 && vysota_land >= 2000 {
            b10_blok6_l = b5_blok6_l
        } else if t_land > 0 && vysota_land <= 1000 {
            b10_blok6_l = b6_blok6_l
        } else if t_land > 0 && vysota_land > 1000 && vysota_land < 2000 {
            b10_blok6_l = b7_blok6_l
        } else {
            b10_blok6_l = b8_blok6_l
        }
        
        b13_blok6_l = (d14_blok6_l - d13_blok6_l) * (0.005 * b10_blok6_l - 9) + d13_blok6_l
        b14_blok6_l = (d15_blok6_l - d14_blok6_l) * (0.005 * b10_blok6_l - 10) + d14_blok6_l
        b15_blok6_l = (d16_blok6_l - d15_blok6_l) * (0.005 * b10_blok6_l - 11) + d15_blok6_l
        b16_blok6_l = (d17_blok6_l - d16_blok6_l) * (0.005 * b10_blok6_l - 12) + d16_blok6_l
        b18_blok6_l = (d19_blok6_l - d18_blok6_l) * (0.005 * b10_blok6_l - 9) + d18_blok6_l
        b19_blok6_l = (d20_blok6_l - d19_blok6_l) * (0.005 * b10_blok6_l - 10) + d19_blok6_l
        b20_blok6_l = (d21_blok6_l - d20_blok6_l) * (0.005 * b10_blok6_l - 11) + d20_blok6_l
        b21_blok6_l = (d22_blok6_l - d20_blok6_l) * (0.0025 * b10_blok6_l - 5.5) + d20_blok6_l
        
        if land_weight <= 80000 && b10_blok6_l <= 2000 {
            potr_pos_dist_ot_m = b13_blok6_l
        } else if land_weight <= 80000 && b10_blok6_l <= 2200 && b10_blok6_l > 2000 {
            potr_pos_dist_ot_m = b14_blok6_l
        } else if land_weight <= 80000 && b10_blok6_l <= 2400 && b10_blok6_l > 2200 {
            potr_pos_dist_ot_m = b15_blok6_l
        } else if land_weight <= 80000 && b10_blok6_l > 2400 {
            potr_pos_dist_ot_m = b16_blok6_l
        } else if land_weight > 80000 && b10_blok6_l <= 2000 {
            potr_pos_dist_ot_m = b18_blok6_l
        } else if land_weight > 80000 && b10_blok6_l <= 2200 && b10_blok6_l > 2000 {
            potr_pos_dist_ot_m = b19_blok6_l
        } else if land_weight > 80000 && b10_blok6_l <= 2400 && b10_blok6_l > 2200 {
            potr_pos_dist_ot_m = b20_blok6_l
        } else {
            potr_pos_dist_ot_m = b21_blok6_l
        }
        /*
         b1 - t_land
         b2 - vysota_land
         b3 - b3_blok6_l
         b4 - b4_blok6_l
         b5 - b5_blok6_l
         b6 - b6_blok6_l
         b7 - b7_blok6_l
         b8 - b8_blok6_l
         b10 - b10_blok6_l
         b11 - potr_pos_dist_ot_m
         b12 - land_weight
         b13 - b13_blok6_l
         b14 - b14_blok6_l
         b15 - b15_blok6_l
         b16 - b16_blok6_l
         b18 - b18_blok6_l
         b19 - b19_blok6_l
         b20 - b20_blok6_l
         b21 - b21_blok6_l
         d2 - d2_blok6_l
         d3 - d3_blok6_l
         d4 - d4_blok6_l
         d5 - d5_blok6_l
         d6 - d6_blok6_l
         d7 - d7_blok6_l
         d8 - d8_blok6_l
         d9 - d9_blok6_l
         d10 - d10_blok6_l
         d11 - d11_blok6_l
         d12 - d12_blok6_l
         d13 - d13_blok6_l
         d14 - d14_blok6_l
         d15 - d15_blok6_l
         d16 - d16_blok6_l
         d17 - d17_blok6_l
         d18 - d18_blok6_l
         d19 - d19_blok6_l
         d20 - d20_blok6_l
         d21 - d21_blok6_l
         d22 - d22_blok6_l
         */
        
        
        //БЛОК 7 (Потребная посадочная дистанция. ОБРАТНЫЙ РАСЧЕТ)
        var potreb_pos_dist_blok7_l, b2_blok7_l: Double
        
        if potr_pos_dist_ot_m <= 2760 && headwind_l < 0 {
            b2_blok7_l = potr_pos_dist_ot_m - (potr_pos_dist_ot_m - (potr_pos_dist_ot_m + 400)) * (-0.2 * headwind_l)
        } else if headwind_l > 0 {
            b2_blok7_l = potr_pos_dist_ot_m - (potr_pos_dist_ot_m - (potr_pos_dist_ot_m - 440.0142) / 1.0556) * (0.05 * headwind_l) * (-0.00278 * headwind_l + 1.0556)
        } else {
            b2_blok7_l = potr_pos_dist_ot_m - (potr_pos_dist_ot_m - (potr_pos_dist_ot_m - 290.0116) / 0.77) * (-0.2 * headwind_l) * (-0.046 * headwind_l + 0.77) * (0.0027457 * pow(headwind_l, 2) + 0.0137 * headwind_l + 1)
        }
        
        if b2_blok7_l > 2600 && slope_l < 0 {
            potreb_pos_dist_blok7_l = b2_blok7_l - (b2_blok7_l - (b2_blok7_l - 100) / 0.9) * (-0.5 * slope_l) * (-0.05 * slope_l + 0.9)
        } else if b2_blok7_l <= 2900 {
            potreb_pos_dist_blok7_l = b2_blok7_l - (b2_blok7_l - (b2_blok7_l + 29.2381) / 1.0729) * (0.5 * slope_l) * (-0.0364 * slope_l + 1.0729)
        } else {
            potreb_pos_dist_blok7_l = b2_blok7_l - (b2_blok7_l - (b2_blok7_l - 200)) * (0.5 * slope_l)
        }
        
        /*
         a2 - potreb_pos_dist_blok7_l
         a3 - slope_l
         a4 - b2_blok7_l
         b2 - b2_blok7_l
         b3 - headwind_l
         b4 - potr_pos_dist_ot_m
         c4 - potr_pos_dist_ot_m
         */
        

        //БЛОК 8 (Потребная длина ВПП с учетом ее состояния на посадке. ОБРАТНЫЙ РАСЧЕТ)
        var podreb_dl_vpp_blok8_l, b4_blok8_l: Double
        b4_blok8_l = potreb_pos_dist_blok7_l - (potreb_pos_dist_blok7_l - (potreb_pos_dist_blok7_l + 4.5559) / 0.6833) * (2.11111 - 3.7037 * k_br_l_blok4) * (-1.172 * k_br_l_blok4 + 1.3516) * (1.9349 * pow(k_br_l_blok4, 2) - 1.6834 * k_br_l_blok4 + 1.3309)
        
        if b3_blok4_l {
            podreb_dl_vpp_blok8_l = potreb_pos_dist_blok7_l / 0.73333333333
        } else {
            podreb_dl_vpp_blok8_l = b4_blok8_l
        }
        
        /*
         b2 - podreb_dl_vpp_blok8_l
         b3 - b3_blok4_l
         b4 - b4_blok8_l
         b5 - k_br_l_blok4
         b6 - potreb_pos_dist_blok7_l
         */
        
        
        //БЛОК 9 (Скорости на посадке)
        var v_l_18, v_l_26, v_l_37: Double
        
        v_l_18 = (0.0014063 * land_weight + 130.6231)
        if (0.0015172 * land_weight + 114.4147) < 215 {
            v_l_26 = 215
        } else {
            v_l_26 = 0.0015172 * land_weight + 114.4147
        }
        
        if (0.0014583 * land_weight + 110.8375) < 215 {
            v_l_37 = 215
        } else {
            v_l_37 = 0.0014583 * land_weight + 110.8375
        }

        /*
         b1 - land_weight
         b2 - v_l_18
         b3 - v_l_26
         b4 - v_l_37  (Vref)
         */

        
        //БЛОК 10 (Посадочная масса, ограниченная посадочной дистанцией)
        var b3_blok10_l, b4_blok10_l, b5_blok10_l, b6_blok10_l, b7_blok10_l, b8_blok10_l, b10_blok10_l, m_ogr_pos_dist_blok10, b13_blok10_l, b14_blok10_l, b15_blok10_l, b16_blok10_l, b18_blok10_l, b19_blok10_l, b20_blok10_l, b21_blok10_l: Double
        var d2_blok10_l, d3_blok10_l, d4_blok10_l, d5_blok10_l, d6_blok10_l, d7_blok10_l, d8_blok10_l, d9_blok10_l, d10_blok10_l, d11_blok10_l, d12_blok10_l: Double
        
        d2_blok10_l = 0.01 * pow(t_land, 2) + 3.5 * t_land + 1850
        d3_blok10_l = 0.0125 * pow(t_land, 2) + 3.9 * t_land + 1996
        d4_blok10_l = 0.0075 * pow(t_land, 2) + 4.05 * t_land + 2200
        d5_blok10_l = 3.8 * t_land + 2400
        d6_blok10_l = 0.0371111 * pow(t_land, 2) + 4.50778 * t_land + 1850
        d7_blok10_l = 0.0764897 * pow(t_land, 2) + 3.82021 * t_land + 1996
        d8_blok10_l = 0.0488975 * pow(t_land, 2) + 4.72205 * t_land + 2200
        d9_blok10_l = 6.45161 * t_land + 2400
        d10_blok10_l = 0.001 * vysota_land
        d11_blok10_l = 0.001 * vysota_land - 1
        d12_blok10_l = 0.001 * vysota_land - 2
        
        b3_blok10_l = (d3_blok10_l - d2_blok10_l) * d10_blok10_l + d2_blok10_l
        b4_blok10_l = (d4_blok10_l - d3_blok10_l) * d11_blok10_l + d3_blok10_l
        b5_blok10_l = (d5_blok10_l - d4_blok10_l) * d12_blok10_l + d4_blok10_l
        b6_blok10_l = (d7_blok10_l - d6_blok10_l) * d10_blok10_l + d6_blok10_l
        b7_blok10_l = (d8_blok10_l - d7_blok10_l) * d11_blok10_l + d7_blok10_l
        b8_blok10_l = (d9_blok10_l - d8_blok10_l) * d12_blok10_l + d8_blok10_l
        
        if t_land <= 0 && vysota_land <= 1000 {
            b10_blok10_l = b3_blok10_l
        } else if t_land <= 0 && vysota_land > 1000 && vysota_land < 2000 {
            b10_blok10_l = b4_blok10_l
        } else if t_land <= 0 && vysota_land >= 2000 {
            b10_blok10_l = b5_blok10_l
        } else if t_land > 0 && vysota_land <= 1000 {
            b10_blok10_l = b6_blok10_l
        } else if t_land > 0 && vysota_land > 1000 && vysota_land < 2000 {
            b10_blok10_l = b7_blok10_l
        } else {
            b10_blok10_l = b8_blok10_l
        }
        
        b13_blok10_l = (1 / (3 * b10_blok10_l - 3700)) * 20000 * (sqrt(-59 * pow(b10_blok10_l, 2) + 75 * b10_blok10_l * rpd_ap_osn + 57700 * b10_blok10_l - 92500 * rpd_ap_osn + 18922500) + 8 * b10_blok10_l - 10450)
        b14_blok10_l = (1000 * (sqrt(-4031 * pow(b10_blok10_l, 2) + 8000 * b10_blok10_l * rpd_ap_osn - 7237600 * b10_blok10_l - 1280000 * rpd_ap_osn + 4569760000) + 17 * b10_blok10_l + 54800)) / (b10_blok10_l - 160)
        b15_blok10_l = (5000 * (sqrt(-28071 * pow(b10_blok10_l, 2) + 43200 * b10_blok10_l * rpd_ap_osn + 29618400 * b10_blok10_l - 78720000 * rpd_ap_osn + 39840160000) + 309 * b10_blok10_l - 587600)) / (3 * (9 * b10_blok10_l - 16400))
        b16_blok10_l = (5000 * (-sqrt(8881 * pow(b10_blok10_l, 2) - 8800 * b10_blok10_l * rpd_ap_osn - 26888400 * b10_blok10_l + 27360000 * rpd_ap_osn + 686440000) + 185 * b10_blok10_l - 521000)) / (11 * b10_blok10_l - 34200)
        b18_blok10_l = (3.25261 * pow(10, (-15)) * (sqrt(-5.85786 * pow(10, 43) * pow(b10_blok10_l, 2) + b10_blok10_l * (5.90768 * pow(10, 43) * rpd_ap_osn + 7.0578 * pow(10, 46)) - 7.61435 * pow(10, 46) * rpd_ap_osn + 1.55718 * pow(10, 49)) + 1.60769 * pow(10, 22) * b10_blok10_l - 2.37588 * pow(10, 25))) / (625 * b10_blok10_l - 805556)
        b19_blok10_l = (-2.32589 * pow(10, (-15)) * sqrt(-6.50195 * pow(10, 37) * pow(b10_blok10_l, 2) + 7.00488 * pow(10, 37) * b10_blok10_l * rpd_ap_osn + 1.14207 * pow(10, 41) * b10_blok10_l - 1.283 * pow(10, 41) * rpd_ap_osn + 9.87566 * pow(10, 42)) - 74789.9 * b10_blok10_l + 1.39232 * pow(10, 8)) / (1831.58 - b10_blok10_l)
        b20_blok10_l = (1.1393 * pow(10, (-14)) * sqrt(1.99038 * pow(10, 37) * pow(b10_blok10_l, 2) - 7.92432 * pow(10, 36) * b10_blok10_l * rpd_ap_osn - 7.11957 * pow(10, 40) * b10_blok10_l + 2.53578 * pow(10, 40) * rpd_ap_osn + 4.38489 * pow(10, 43)) - 119430 * b10_blok10_l + 3.31432 * pow(10, 8)) / (3200 - b10_blok10_l)
        b21_blok10_l = (-4.12198 * pow(10, (-14)) * sqrt(-2.49042 * pow(10, 35) * pow(b10_blok10_l, 2) + 4.29777 * pow(10, 35) * b10_blok10_l * rpd_ap_osn + 1.08526 * pow(10, 37) * b10_blok10_l - 6.40394 * pow(10, 38) * rpd_ap_osn + 5.48219 * pow(10, 41)) - 62474.2 * b10_blok10_l + 8.86805 * pow(10, 7)) / (1490.06 - b10_blok10_l)

        if rpd_ap_osn <= b10_blok10_l && b10_blok10_l <= 2000 {
            m_ogr_pos_dist_blok10 = b13_blok10_l
        } else if rpd_ap_osn <= b10_blok10_l && b10_blok10_l > 2000 && b10_blok10_l<=2200 {
            m_ogr_pos_dist_blok10 = b14_blok10_l
        } else if rpd_ap_osn <= b10_blok10_l && b10_blok10_l > 2200 && b10_blok10_l <= 2400 {
            m_ogr_pos_dist_blok10 = b15_blok10_l
        } else if rpd_ap_osn <= b10_blok10_l && b10_blok10_l > 2400 {
            m_ogr_pos_dist_blok10 = b16_blok10_l
        } else if rpd_ap_osn > b10_blok10_l && b10_blok10_l <= 2000 {
            m_ogr_pos_dist_blok10 = b18_blok10_l
        } else if rpd_ap_osn > b10_blok10_l && b10_blok10_l > 2000 && b10_blok10_l <= 2200 {
            m_ogr_pos_dist_blok10 = b19_blok10_l
        } else if rpd_ap_osn > b10_blok10_l && b10_blok10_l > 2200 && b10_blok10_l <= 2400 {
            m_ogr_pos_dist_blok10 = b20_blok10_l
        } else {
            m_ogr_pos_dist_blok10 = b21_blok10_l
        }
        
        /*
         b1 - t_land
         b2 - vysota_land
         b3 - b3_blok10_l
         b4 - b4_blok10_l
         b5 - b5_blok10_l
         b6 - b6_blok10_l
         b7 - b7_blok10_l
         b8 - b8_blok10_l
         b10 - b10_blok10_l
         b11 - rpd_ap_osn
         b12 - m_ogr_pos_dist_blok10
         b13 - b13_blok10_l
         b14 - b14_blok10_l
         b15 - b15_blok10_l
         b16 - b16_blok10_l
         b18 - b18_blok10_l
         b19 - b19_blok10_l
         b20 - b20_blok10_l
         b21 - b21_blok10_l
         d2 - d2_blok10_l
         d3 - d3_blok10_l
         d4 - d4_blok10_l
         d5 - d5_blok10_l
         d6 - d6_blok10_l
         d7 - d7_blok10_l
         d8 - d8_blok10_l
         d9 - d9_blok10_l
         d10 - d10_blok10_l
         d11 - d11_blok10_l
         d12 - d12_blok10_l
         */

        
        //БЛОК 11 (Градиенты набора высоты при уходе на 2-ой круг с одним отказавшим двигателем (с креном))
        var b4_blok11_l, b5_blok11_l, b6_blok11_l, b7_blok11_l, b8_blok11_l, b9_blok11_l, b10_blok11_l, b11_blok11_l, b12_blok11_l, b13_blok11_l, b14_blok11_l, b15_blok11_l, b16_blok11_l, b17_blok11_l, grad_nab_vys_blok11_l, grad_nab_vys_10_blok11_l, grad_nab_vys_20_blok11_l, grad_nab_vys_30_blok11_l, sub_grad_nab_vys_10_blok11_l, sub_grad_nab_vys_20_blok11_l, sub_grad_nab_vys_30_blok11_l, sub2_grad_nab_vys_10_blok11_l, sub2_grad_nab_vys_20_blok11_l, sub2_grad_nab_vys_30_blok11_l: Double
        
        b4_blok11_l = 0.5 * (1 - 0.001 * vysota_land) + 5
        b5_blok11_l = 1.3 * (2 - 0.001 * vysota_land) + 3.7
        b6_blok11_l = (5.5 - (5.6666 - 0.0333 * t_land)) * (1 - 0.001 * vysota_land) + (5.6666 - 0.0333 * t_land)
        b7_blok11_l = ((5.6666 - 0.0333 * t_land) - 3.7) * (2 - 0.001 * vysota_land) + 3.7
        b8_blok11_l = ((9.5 - 0.1333 * t_land) - (9.168 - 0.168 * t_land)) * (1 - 0.001 * vysota_land) + (9.168 - 0.168 * t_land)
        b9_blok11_l = ((9.168 - 0.168 * t_land) - (5.9232 - 0.13077 * t_land)) * (2 - 0.001 * vysota_land) + (5.9232 - 0.13077 * t_land)
        b10_blok11_l = 30 - 0.01 * vysota_land
        b11_blok11_l = 30 - 0.004 * vysota_land
        b12_blok11_l = 23 - 0.003 * vysota_land
        b13_blok11_l = 35 - 0.009 * vysota_land
        
        if vysota_land <= 0 && t_land <= b10_blok11_l {
            b14_blok11_l = b4_blok11_l
        } else if vysota_land <= 0 && t_land > b10_blok11_l {
            b14_blok11_l = b8_blok11_l
        } else if vysota_land > 0 && vysota_land <= 1000 && t_land <= b10_blok11_l {
            b14_blok11_l = b4_blok11_l
        } else if vysota_land > 0 && vysota_land <= 1000 && t_land > b10_blok11_l && t_land <= b11_blok11_l {
            b14_blok11_l = b6_blok11_l
        } else if vysota_land > 0 && vysota_land <= 1000 && t_land > b11_blok11_l {
            b14_blok11_l = b8_blok11_l
        } else if vysota_land > 1000 && vysota_land <= 2000 && t_land <= b12_blok11_l {
            b14_blok11_l = b5_blok11_l
        } else if vysota_land > 1000 && vysota_land <= 2000 && t_land > b12_blok11_l && t_land <= b13_blok11_l {
            b14_blok11_l = b7_blok11_l
        } else if vysota_land > 1000 && t_land > b13_blok11_l {
            b14_blok11_l = b9_blok11_l
        } else if vysota_land > 2000 && t_land <= b13_blok11_l {
            b14_blok11_l = b5_blok11_l
        } else {
            b14_blok11_l = 99999999 //ошибка алгоритма
        }

        b15_blok11_l = ((4.4728 * pow(10,(-10)) * pow(land_weight, 2) - 0.0002979 * land_weight + 26.96) - (-1.3355 * pow(10,(-10)) * pow(land_weight, 2) - 0.00016168 * land_weight + 15.779)) * (0.25 * b14_blok11_l - 0.5) + (-1.3355 * pow(10, (-10)) * pow(land_weight, 2) - 0.00016168 * land_weight + 15.779)
        b16_blok11_l = ((1.5567 * pow(10, (-9)) * pow(land_weight, 2) - 0.000435 * land_weight + 30.821) - (1.8964 * pow(10, (-9)) * pow(land_weight, 2) - 0.0004781 * land_weight + 28.116)) * (0.25 * b14_blok11_l - 0.5) + (1.8964 * pow(10, (-9)) * pow(land_weight, 2) - 0.0004781 * land_weight + 28.116)
        
        if land_weight < 80000 {
            b17_blok11_l = b15_blok11_l
        } else {
            b17_blok11_l = b16_blok11_l
        }

        grad_nab_vys_blok11_l = ((-0.0016 * pow(kren, 2) - 0.0638 * kren + 7.992) - (-0.0011796 * pow(kren, 2) - 0.080414 * kren + 3.9805)) * (0.25 * b17_blok11_l - 1) + (-0.0011796 * pow(kren, 2) - 0.080414 * kren + 3.9805)
        
        sub2_grad_nab_vys_10_blok11_l = Double(-0.0016 * pow(10, 2) - 0.0638 * 10 + 7.992)
        sub_grad_nab_vys_10_blok11_l = Double((sub2_grad_nab_vys_10_blok11_l - (-0.0011796 * pow(10, 2) - 0.080414 * 10 + 3.9805)))
        grad_nab_vys_10_blok11_l =  sub_grad_nab_vys_10_blok11_l * (0.25 * b17_blok11_l - 1) + (-0.0011796 * pow(10, 2) - 0.080414 * 10 + 3.9805)
        
        sub2_grad_nab_vys_20_blok11_l = Double(-0.0011796 * pow(20, 2) - 0.080414 * 20 + 3.9805)
        sub_grad_nab_vys_20_blok11_l = Double(((-0.0016 * pow(20, 2) - 0.0638 * 20 + 7.992) - sub2_grad_nab_vys_20_blok11_l))
        grad_nab_vys_20_blok11_l = sub_grad_nab_vys_20_blok11_l * (0.25 * b17_blok11_l - 1) + (-0.0011796 * pow(20, 2) - 0.080414 * 20 + 3.9805)
        
        sub2_grad_nab_vys_30_blok11_l = Double(-0.0011796 * pow(30, 2) - 0.080414 * 30 + 3.9805)
        sub_grad_nab_vys_30_blok11_l = Double(((-0.0016 * pow(30, 2) - 0.0638 * 30 + 7.992) - sub2_grad_nab_vys_30_blok11_l))
        grad_nab_vys_30_blok11_l = sub_grad_nab_vys_30_blok11_l * (0.25 * b17_blok11_l - 1) + (-0.0011796 * pow(30, 2) - 0.080414 * 30 + 3.9805)
        
        /*
         b1 - t_land
         b2 - vysota_land
         b3 - land_weight
         b4 - b4_blok11_l
         b5 - b5_blok11_l
         b6 - b6_blok11_l
         b7 - b7_blok11_l
         b8 - b8_blok11_l
         b9 - b9_blok11_l
         b10 - b10_blok11_l
         b11 - b11_blok11_l
         b12 - b12_blok11_l
         b13 - b13_blok11_l
         b14 - b14_blok11_l
         b15 - b15_blok11_l
         b16 - b16_blok11_l
         b17 - b17_blok11_l
         b18 - kren
         b19 - grad_nab_vys_blok11_l
         b20 - grad_nab_vys_10_blok11_l
         b21 - grad_nab_vys_20_blok11_l
         b22 - grad_nab_vys_30_blok11_l
         */
        
        
        //БЛОК максимально допустимая посадочная масса
        var m_land_max_fin: Double
        if min(m_ogr_pos_dist_blok10, m_grad_l) > m_land_max {
            m_land_max_fin = m_land_max
        } else {
            m_land_max_fin = min(m_ogr_pos_dist_blok10, m_grad_l)
        }
        
        
        //БЛОК crosswind max
        var crosswind_l_max: Double
        if b3_blok4_l {
            crosswind_l_max = 5
        } else {
            crosswind_l_max = (33.3333 * k_br_l - 5)
        }
        
        //ОКРУГЛЕНИЕ
            //округление скоростей вверх до 5
        v_l_18 = ((v_l_18 / 5).rounded(.up)) * 5
        v_l_26 = ((v_l_26 / 5).rounded(.up)) * 5
        v_l_37 = ((v_l_37 / 5).rounded(.up)) * 5
        
        crosswind_l_max = (crosswind_l_max * 10).rounded()/10
        crosswind_l = (crosswind_l * 10).rounded()/10
        headwind_l = (headwind_l * 10).rounded()/10
        qfe_land = (qfe_land * 10).rounded()/10
        mm_rt_st_land = (mm_rt_st_land * 10).rounded()/10
        vysota_land = (vysota_land).rounded()
        m_land_max_fin = (m_land_max_fin * 10).rounded()/10
        grad_nab_vys_blok11_l = (grad_nab_vys_blok11_l * 10).rounded()/10
        grad_nab_vys_10_blok11_l = (grad_nab_vys_10_blok11_l * 10).rounded()/10
        grad_nab_vys_20_blok11_l = (grad_nab_vys_20_blok11_l * 10).rounded()/10
        grad_nab_vys_30_blok11_l = (grad_nab_vys_30_blok11_l * 10).rounded()/10
        podreb_dl_vpp_blok8_l = (podreb_dl_vpp_blok8_l).rounded()
        
   
        
        // ВЫВОД РЕЗУЛЬТАТОВ
        
       labelTest.text = " Crosswind MAX = \(Double(crosswind_l_max)) , Crosswind ACTUAL = \(Double(crosswind_l)) \n HEADWIND = \(Double(headwind_l)) \n \n QFE = \(Double(qfe_land)) / \(Double(mm_rt_st_land)) мм.рт.ст.    Elev = \(Double(vysota_land)) \n \n MAX LANDING MASS = \(Double(m_land_max_fin)) \n \n Град.ухода на 2-й: \(Double(grad_nab_vys_blok11_l))%, крен10 = \(Double(grad_nab_vys_10_blok11_l))%, крен20 = \(Double(grad_nab_vys_20_blok11_l))%, крен30 = \(Double(grad_nab_vys_30_blok11_l))% \n \n Vref = \(Double(v_l_37)) \n V18 =  \(Double(v_l_18)), V26 = \(Double(v_l_26)) \n Потребная длина ВПП = \(Double(podreb_dl_vpp_blok8_l))"
        
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func ldaTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "LDA (Landing Distance Available) - Располагаемая посадочная дистанция", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    
    @IBAction func elevTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "Elevation - превышение аэродрома - высота самой высокой точки ВПП относительно уровня моря", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    
    @IBAction func slopeTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "Slope - средний уклон между двумя концами или точками на ВПП (разность высот между двумя указанными точками, деленная на расстояние между ними). Выражается в процентах, перед которыми ставится знак «плюс», если уклон восходящий, или «минус», если уклон нисходящий", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    @IBAction func hdgTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "Heading - курс оси ВПП согласно магнитному курсу", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    
    @IBAction func kscepTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "Коэффициент сцепления ВПП", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    
    @IBAction func oatTap(_ sender:
        UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "OAT - Outside Air Temperature - температура наружного воздуха", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    
    @IBAction func qnhTap(_ sender: UITapGestureRecognizer) {
        let helpalert = UIAlertController(title: "Справка", message: "QNH - атмосферное давление в районе аэродрома, приведенное к среднему уровню моря (MSL). Указывается в гектопаскалях. Сообщается по ATIS и органами УВД по запросу экипажа", preferredStyle: .alert)
        let okbutton = UIAlertAction(title: "ОК", style: .cancel, handler: nil)
        helpalert.addAction(okbutton)
        self.present(helpalert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

