//
//  File.swift
//  Draw
//
// 
//

import UIKit

class CorrectPoints: NSObject {
    //    static let applePoints : [CGPoint] = [CGPoint(x: 772, y: 154),    // 1
    //                                   CGPoint(x: 663, y: 157),           // 2
    //                                   CGPoint(x: 602, y: 238),           // 3
    //                                   CGPoint(x: 550, y: 201),           // 4
    //                                   CGPoint(x: 600, y: 331),           // 5
    //                                   CGPoint(x: 702, y: 249),           // 6
    //                                   CGPoint(x: 493, y: 320),           // 7
    //                                   CGPoint(x: 406, y: 436),           // 8
    //                                   CGPoint(x: 445, y: 563),           // 9
    //                                   CGPoint(x: 528, y: 637),           // 10
    //                                   CGPoint(x: 600, y: 611),           // 11
    //                                   CGPoint(x: 672, y: 635),           // 12
    //                                   CGPoint(x: 754, y: 562),           // 13
    //                                   CGPoint(x: 795, y: 445),           // 14
    //                                   CGPoint(x: 722, y: 327),           // 15
    //                                   CGPoint(x: 535, y: 378),           // 16
    //                                   CGPoint(x: 488, y: 395),           // 17
    //                                   CGPoint(x: 471, y: 441)            // 18
    
    
    static let applePoints : [CGPoint] = [ CGPoint(x: 597 , y: 296),
                                           CGPoint(x: 637 , y: 285),
                                           CGPoint(x: 716 , y: 314),
                                           CGPoint(x: 737 , y: 331),
                                           CGPoint(x:  752 , y: 415),
                                           CGPoint(x:  623 , y: 582),
                                           CGPoint(x:  666, y:  560),
                                           CGPoint(x:  714, y:  544),
                                           CGPoint(x:  743, y:  494),
                                           CGPoint(x: 750 , y: 452),
                                           CGPoint(x: 469 , y: 455),
                                           CGPoint(x:  473, y:  460),
                                           CGPoint(x: 467 , y: 455),
                                           CGPoint(x: 511, y:  524),
                                           CGPoint(x: 515 , y: 529),
                                           CGPoint(x: 545 , y: 557),
                                           CGPoint(x:  597 , y: 592),
                                           CGPoint(x: 606 , y: 306),
                                           CGPoint(x:  608 , y: 310),
                                           CGPoint(x:  594 , y: 301),
                                           CGPoint(x:  570 , y: 285),
                                           CGPoint(x:  556, y:  287),
                                           CGPoint(x: 495 , y: 301),
                                           CGPoint(x:  489 , y: 344),
                                           CGPoint(x: 526 , y: 539),
                                           CGPoint(x:  606 , y:305),
                                           CGPoint(x: 624 , y:317),
                                           CGPoint(x: 613, y: 275),
                                           CGPoint(x: 631, y: 293),
                                           CGPoint(x: 626, y: 283),
                                           CGPoint(x:  649, y: 248),
                                           CGPoint(x:  648, y: 219),
                                           CGPoint(x:  564 , y:225),
                                           CGPoint(x: 551, y: 213),
                                           CGPoint(x:  566, y: 231),
                                           CGPoint(x: 552, y: 208),
                                           CGPoint(x: 577, y: 237),
                                           CGPoint(x: 616, y: 277)
                                           
    ]
    
    
    
    static let duckPoints : [CGPoint] = [
//        CGPoint(x:  562 , y:345),
//        CGPoint(x:   573 , y:351),
//        CGPoint(x:   572, y: 347),
//        CGPoint(x:   578 , y:319),
//        CGPoint(x:    658, y: 210),
//        CGPoint(x:   674 , y:225),
//        CGPoint(x:  674 , y:225),
//        CGPoint(x:   705 , y:236),
//        CGPoint(x:   718, y: 251),
//        CGPoint(x:   740 , y:280),
//        CGPoint(x:   724 , y:280),
//        CGPoint(x:   732 , y:292),
//        CGPoint(x:   729 , y:288),
//        CGPoint(x:   673 , y:530),
//        CGPoint(x:  648 , y:549),
//        CGPoint(x:  644, y: 553),
//        CGPoint(x:  664, y: 586),
//        CGPoint(x:  625 , y:595),
//        CGPoint(x: 662, y: 585),
//        CGPoint(x:  658, y: 569),
//        CGPoint(x: 670, y: 546),
//        CGPoint(x: 698 , y:562),
//        CGPoint(x: 507, y: 369),
//        CGPoint(x: 463 , y:419),
//        CGPoint(x: 447, y: 417),
//        CGPoint(x: 459, y: 439),
//        CGPoint(x:  475 , y:495),
//        CGPoint(x:  510 , y:557),
//        CGPoint(x: 571, y: 595),
//        CGPoint(x:  643 , y:620),
//        CGPoint(x:  545 , y:578),
//        CGPoint(x: 571, y: 623),
//
//        CGPoint(x: 716, y: 299),
//        CGPoint(x:  712 , y:309),
//        CGPoint(x:  741 , y:351),
//        CGPoint(x:  756, y: 350),
//        CGPoint(x:  764 , y:302),
//        CGPoint(x:  771 , y:318),
//        CGPoint(x:  756 , y:315),
//
//
//        //        eyes
//        CGPoint(x: 674, y: 316),
//        CGPoint(x: 686 , y:306),
//        CGPoint(x: 686, y: 335),
//        CGPoint(x: 645 , y:442),
//        CGPoint(x: 618 , y:431),
//        CGPoint(x: 615, y: 451),
//        CGPoint(x:  603 , y:473)
        
    ]
    
    static let moonPoints : [CGPoint] = [
        
        CGPoint(x: 507.0, y: 168.5),
        CGPoint(x: 497.5, y: 172.0),
        CGPoint(x: 488.0, y: 178.0),
        CGPoint(x: 479.0, y: 185.0),
        CGPoint(x: 470.5, y: 190.5),
        CGPoint(x: 460.0, y: 199.0),
        CGPoint(x: 449.5, y: 207.0),
        CGPoint(x: 440.0, y: 217.5),
        CGPoint(x: 432.0, y: 227.0),
        CGPoint(x: 424.0, y: 240.0),
        CGPoint(x: 415.5, y: 251.5),
        CGPoint(x: 407.5, y: 264.5),
        CGPoint(x: 400.5, y: 279.5),
        CGPoint(x: 394.5, y: 293.5),
        CGPoint(x: 388.5, y: 305.5),
        CGPoint(x: 387.5, y: 320.5),
        CGPoint(x: 385.0, y: 332.0),
        CGPoint(x: 384.0, y: 345.0),
        CGPoint(x: 383.0, y: 358.0),
        CGPoint(x: 383.0, y: 372.0),
        CGPoint(x: 380.5, y: 385.0),
        CGPoint(x: 384.0, y: 402.5),
        CGPoint(x: 386.5, y: 416.5),
        CGPoint(x: 387.5, y: 425.5),
        CGPoint(x: 388.5, y: 434.0),
        CGPoint(x: 393.5, y: 445.5),
        CGPoint(x: 397.0, y: 457.5),
        CGPoint(x: 402.5, y: 469.0),
        CGPoint(x: 407.5, y: 478.5),
        CGPoint(x: 412.0, y: 489.0),
        CGPoint(x: 418.0, y: 496.0),
        CGPoint(x: 424.0, y: 504.0),
        CGPoint(x: 428.5, y: 512.5),
        CGPoint(x: 435.5, y: 520.5),
        CGPoint(x: 442.5, y: 527.5),
        CGPoint(x: 449.5, y: 534.5),
        CGPoint(x: 456.5, y: 541.5),
        CGPoint(x: 463.5, y: 547.5),
        CGPoint(x: 472.0, y: 553.0),
        CGPoint(x: 480.0, y: 560.5),
        CGPoint(x: 488.0, y: 566.0),
        CGPoint(x: 497.5, y: 571.0),
        CGPoint(x: 505.5, y: 575.5),
        CGPoint(x: 514.0, y: 579.0),
        CGPoint(x: 522.0, y: 583.5),
        CGPoint(x: 531.5, y: 586.0),
        CGPoint(x: 542.0, y: 590.5),
        CGPoint(x: 552.5, y: 593.0),
        CGPoint(x: 562.0, y: 595.5),
        CGPoint(x: 571.5, y: 599.0),
        CGPoint(x: 584.0, y: 599.0),
        CGPoint(x: 594.5, y: 600.0),
        CGPoint(x: 606.5, y: 601.0),
        CGPoint(x: 618.0, y: 600.0),
        CGPoint(x: 632.0, y: 600.0),
        CGPoint(x: 642.5, y: 600.0),
        CGPoint(x: 655.5, y: 597.5),
        CGPoint(x: 667.5, y: 594.0),
        CGPoint(x: 679.0, y: 592.0),
        CGPoint(x: 689.5, y: 587.0),
        CGPoint(x: 701.0, y: 585.0),
        CGPoint(x: 710.5, y: 579.0),
        CGPoint(x: 720.0, y: 575.5),
        CGPoint(x: 728.0, y: 569.5),
        CGPoint(x: 736.5, y: 562.5),
        CGPoint(x: 744.5, y: 559.0),
        CGPoint(x: 754.0, y: 553.0),
        CGPoint(x: 762.0, y: 545.0),
        CGPoint(x: 769.0, y: 538.0),
        CGPoint(x: 777.5, y: 530.0),
        CGPoint(x: 785.5, y: 523.0),
        CGPoint(x: 791.5, y: 514.5),
        CGPoint(x: 798.5, y: 506.5),
        CGPoint(x: 802.0, y: 498.5),
        CGPoint(x: 807.5, y: 491.5),
        CGPoint(x: 812.5, y: 485.5),
        CGPoint(x: 814.5, y: 477.0),
        CGPoint(x: 805.5, y: 479.5),
        CGPoint(x: 798.5, y: 483.0),
        CGPoint(x: 789.0, y: 485.5),
        CGPoint(x: 778.5, y: 487.5),
        CGPoint(x: 769.0, y: 490.0),
        CGPoint(x: 759.5, y: 491.5),
        CGPoint(x: 749.0, y: 495.0),
        CGPoint(x: 737.5, y: 495.0),
        CGPoint(x: 729.5, y: 495.0),
        CGPoint(x: 719.0, y: 495.0),
        CGPoint(x: 709.5, y: 495.0),
        CGPoint(x: 699.0, y: 495.0),
        CGPoint(x: 689.5, y: 493.5),
        CGPoint(x: 680.0, y: 490.0),
        CGPoint(x: 667.5, y: 490.0),
        CGPoint(x: 656.5, y: 486.5),
        CGPoint(x: 646.0, y: 483.0),
        CGPoint(x: 634.5, y: 479.5),
        CGPoint(x: 624.0, y: 475.0),
        CGPoint(x: 615.5, y: 473.5),
        CGPoint(x: 607.0, y: 468.0),
        CGPoint(x: 597.0, y: 462.0),
        CGPoint(x: 588.5, y: 456.5),
        CGPoint(x: 580.5, y: 450.0),
        CGPoint(x: 572.0, y: 443.5),
        CGPoint(x: 564.5, y: 437.0),
        CGPoint(x: 557.0, y: 430.5),
        CGPoint(x: 551.5, y: 424.0),
        CGPoint(x: 545.0, y: 417.5),
        CGPoint(x: 539.5, y: 411.0),
        CGPoint(x: 533.0, y: 403.5),
        CGPoint(x: 528.0, y: 394.5),
        CGPoint(x: 504.0, y: 176.0),
        CGPoint(x: 502.0, y: 185.5),
        CGPoint(x: 497.5, y: 195.5),
        CGPoint(x: 495.5, y: 204.0),
        CGPoint(x: 493.0, y: 215.0),
        CGPoint(x: 490.0, y: 223.5),
        CGPoint(x: 488.0, y: 234.5),
        CGPoint(x: 488.0, y: 245.5),
        CGPoint(x: 487.5, y: 256.0),
        CGPoint(x: 488.0, y: 267.0),
        CGPoint(x: 488.0, y: 279.0),
        CGPoint(x: 488.0, y: 287.5),
        CGPoint(x: 489.0, y: 296.0),
        CGPoint(x: 490.0, y: 303.5),
        CGPoint(x: 493.0, y: 311.5),
        CGPoint(x: 495.0, y: 322.0),
        CGPoint(x: 497.5, y: 331.0),
        CGPoint(x: 500.5, y: 338.5),
        CGPoint(x: 502.0, y: 344.0),
        CGPoint(x: 506.0, y: 353.5),
        CGPoint(x: 508.5, y: 361.0),
        CGPoint(x: 524.5, y: 389.0),
        CGPoint(x: 520.0, y: 382.5),
        CGPoint(x: 515.0, y: 376.0),
        CGPoint(x: 512.5, y: 369.5),
        CGPoint(x: 381.5, y: 392.5),
        CGPoint(x: 383.0, y: 407.5),
        CGPoint(x: 382.5, y: 366.5),
        CGPoint(x: 389.5, y: 312.5),
        CGPoint(x: 397.0, y: 289.5),
        CGPoint(x: 405.5, y: 272.5),
        CGPoint(x: 412.0, y: 258.5),
        CGPoint(x: 419.5, y: 245.5),
        CGPoint(x: 428.0, y: 231.0),
        CGPoint(x: 444.5, y: 212.0),
        CGPoint(x: 455.5, y: 204.0),
        CGPoint(x: 465.0, y: 194.5),
        CGPoint(x: 380.5, y: 378.5)
        
    ]
    
    
    
    
    
    
    
    
}










/*
 
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 1
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 2
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 3
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 4
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 5
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 6
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 7
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 8
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 9
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 10
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 11
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 12
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 13
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 14
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 15
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 16
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 17
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),// 18
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 CGPoint(x: <#T##CGFloat#>, y: <#T##CGFloat#>),
 */
