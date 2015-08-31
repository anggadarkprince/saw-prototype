<?php
/**
 * Created by PhpStorm.
 * User: Asus
 * Date: 6/29/14
 * Time: 9:52 AM
 */

    include_once "Database.php";

    class Model extends Database{

        private $data_pilihan_user;
        private $data_normalisasi;
        private $data_rangking;
        private $data_user;

        public function __construct(){

        }

        private function data_pilihan($id){
            $this->data_pilihan_user = array();
            $this->data_user = array();

            // query mendapatkan data user berdasarkan id lowongan
            $this->ReadWhere("user_lowongan",array("id_lowongan"=>$id));
            $this->data_user = $this->FetchData();

            // query mendapatkan hasil pilihan user
            foreach($this->data_user as $data){
                $this->ManualQuery("
                    SELECT
                      id_user, bobot

                      FROM user_lowongan
                        INNER JOIN pilihan
                        ON user_lowongan.id_user_lowongan=pilihan.id_user_lowongan

                        INNER JOIN subnilai
                        ON pilihan.id_sub=subnilai.id_sub

                        WHERE id_user=".$data['id_user']
                );

                // temporary menyimpan pilihan per user vertical
                $data_pilihan = $this->FetchData();

                // temporary menyimpan pilihan per user horizontal
                $pilih = array();
                foreach($data_pilihan as $pilihan){
                    // push array pilih dari data_pilihan
                    array_push($pilih, $pilihan['bobot']);
                }
                // push pilihan user ke data_pilihan_user
                array_push($this->data_pilihan_user,$pilih);
            }


            $data = array();
            for ($i = 0; $i < sizeof($this->data_pilihan_user); $i++) {
                $temp = array();

                $this->ReadSingleData('user',array('id_user'=>$this->data_user[$i]['id_user']));
                $user = $this->FetchDataRow();
                array_push($temp,$user['nama']);
                for ($j = 0; $j < sizeof($this->data_pilihan_user[$i]); $j++) {
                    array_push($temp,$this->data_pilihan_user[$i][$j]);
                }
                array_push($data,$temp);
            }

            return $data;
        }


        private function normalisasi($id){
            $this->data_normalisasi = array();

            // query untuk mendapatkan attribut dari kriteria
            $this->ManualQuery("
                SELECT atribut
                  FROM kriteria_lowongan

                  INNER JOIN lowongan
                    ON kriteria_lowongan.id_lowongan = lowongan.id_lowongan

                    WHERE lowongan.id_lowongan=".$id
            );

            // data atribut vertical
            $data_atribut = $this->FetchData();

            // temporary array atribut horizontal
            $atribut= array();

            foreach($data_atribut as $val){
                array_push($atribut,$val["atribut"]);
            }

            // loop data pilihan user row
            for($i=0;$i<sizeof($this->data_pilihan_user);$i++){
                $user = array();

                // loop data pilihan user column
                for($j=0;$j<sizeof($this->data_pilihan_user[$i]);$j++){

                    // temporary untuk menampung pilihan dari pilihan yang lain
                    $tmp = array();
                    for ($k = 0; $k < sizeof($this->data_pilihan_user); $k++) {
                        $tmp[$k] = $this->data_pilihan_user[$k][$j];
                    }

                    $normal = null;
                    // jika atribut benefit
                    if($atribut[$j] == "BENEFIT"){
                        $normal = $this->data_pilihan_user[$i][$j] / $this->get_max($tmp);
                    }
                    // jika atribut cost
                    else if($atribut[$j] == "COST"){
                        $normal = $this->get_min($tmp) / $this->data_pilihan_user[$i][$j];
                    }
                    // data normalisasi per user
                    array_push($user,$normal);
                }
                // data normalisasi
                array_push($this->data_normalisasi,$user);
            }

            $data = array();
            for ($i = 0; $i < sizeof($this->data_normalisasi); $i++) {
                $temp = array();

                $this->ReadSingleData('user',array('id_user'=>$this->data_user[$i]['id_user']));
                $user = $this->FetchDataRow();
                array_push($temp,$user['nama']);
                for ($j = 0; $j < sizeof($this->data_normalisasi[$i]); $j++) {
                    array_push($temp,$this->data_normalisasi[$i][$j]);
                }
                array_push($data,$temp);
            }

            return $data;
        }

        private function get_max($data){
            $max = $data[0];
            foreach($data as $val){
                if($val > $max){
                    $max = $val;
                }
            }
            return $max;
        }

        private function get_min($data){
            $min = $data[0];
            foreach($data as $val){
                if($val < $min){
                    $min = $val;
                }
            }
            return $min;
        }


        private function rangking($id){
            $this->data_rangking = array();

            // query mendapatkan bobot kriteria berdasarkan id lowongan
            $this->ManualQuery("
                SELECT bobot
                  FROM kriteria_lowongan

                  INNER JOIN lowongan
                    ON kriteria_lowongan.id_lowongan = lowongan.id_lowongan

                    WHERE lowongan.id_lowongan=".$id
            );

            $data_bobot = $this->FetchData();

            // rubah data horizontal ke vertical
            $bobot= array();
            foreach($data_bobot as $val){
                array_push($bobot,$val["bobot"]);
            }

            // loop menghitung nilai v dari data_normalisasi
            for ($i = 0; $i < sizeof($this->data_normalisasi); $i++) {
                $tmp = 0;
                for ($j = 0; $j < sizeof($this->data_normalisasi[$i]); $j++) {
                    $tmp += $this->data_normalisasi[$i][$j] * $bobot[$j];
                }
                array_push($this->data_rangking,$tmp);
            }

            // sorting buble sort
            for ($k = 0; $k < sizeof($this->data_rangking); $k++) {
                for ($l = sizeof($this->data_rangking) - 1; $l > $k; $l--) {
                    if ($this->data_rangking[$l] > $this->data_rangking[$l - 1]) {
                        $tmp = $this->data_rangking[$l];
                        $this->data_rangking[$l] = $this->data_rangking[$l - 1];
                        $this->data_rangking[$l - 1] = $tmp;

                        $tmp2 = $this->data_user[$l];
                        $this->data_user[$l] = $this->data_user[$l - 1];
                        $this->data_user[$l - 1] = $tmp2;
                    }
                }
            }


            $data = array();
            for ($i = 0; $i < sizeof($this->data_user); $i++) {

                $this->ReadSingleData('user',array('id_user'=>$this->data_user[$i]['id_user']));
                $user = $this->FetchDataRow();
                array_push($data, array($this->data_user[$i]['id_user'],$user['nama'],$this->data_rangking[$i]));
            }

            return $data;
        }


        public function get_pilihan($id){
            return $this->data_pilihan($id);
        }

        public function get_normalisasi($id){
            $this->data_pilihan($id);
            return $this->normalisasi($id);
        }

        public function get_rangking($id){
            $this->data_pilihan($id);
            $this->normalisasi($id);
            return $this->rangking($id);
        }

        public function get_nama_kriteria($id){
            $this->ManualQuery("SELECT kriteria FROM kriteria_lowongan INNER JOIN kriteria ON kriteria_lowongan.id_kriteria = kriteria.id_kriteria WHERE id_lowongan=".$id);
            $data = array();
            foreach($this->FetchData() as $row){
                array_push($data,$row['kriteria']);
            }
            return $data;
        }

    }

