<?php
/**
 * Created by PhpStorm.
 * User: Asus
 * Date: 6/29/14
 * Time: 11:09 AM
 */

    include_once "Model.php";
    $model = new Model();


?>
Data Awal
<table style="border-collapse: collapse;" border="1">
    <tr>
        <th>Nama</th>
        <?php
        foreach($model->get_nama_kriteria(1) as $data){
            ?>
            <th><?=$data?></th>
        <?php
        }
        ?>
    </tr>


    <?php
    foreach($model->get_pilihan(1) as $data){
        ?>
        <tr>
            <?php
            foreach($data as $val){
                ?>
                <td><?=$val?></td>
            <?php
            }

            ?>

        </tr>

    <?php
    }
    ?>
</table>

<br>
Data Normalisasi
<table style="border-collapse: collapse;" border="1">
    <tr>
        <th>Nama</th>
        <?php
        foreach($model->get_nama_kriteria(1) as $data){
            ?>
            <th><?=$data?></th>
        <?php
        }
        ?>
    </tr>


    <?php
    foreach($model->get_normalisasi(1) as $data){
        ?>
        <tr>
            <?php
            foreach($data as $val){
                ?>
                <td><?=$val?></td>
            <?php
            }

            ?>

        </tr>

    <?php
    }
    ?>
</table>

<br>
Data Rangking
<table style="border-collapse: collapse;" border="1">
    <tr>
        <th>ID</th>
        <th>Nama</th>
        <th>Rank</th>
    </tr>


    <?php
    $no=0;
    foreach($model->get_rangking(1) as $data){
        $no++;
        ?>

        <tr>
            <td><?=$no?></td>
            <td><?=$data[1]?></td>
            <td><?=$data[2]?></td>
        </tr>
    <?php
    }
    ?>
</table>







