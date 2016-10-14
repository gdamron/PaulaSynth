// Playground - noun: a place where people can play

import Cocoa
import AVFoundation
import XCPlayground

//XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

let numBuffers = 3
let samplesPerBuffer:AVAudioFrameCount = 1024
var bufferIndex = 0
let test = 50

let format = AVAudioFormat(standardFormatWithSampleRate: 44100.0, channels: 2)

var buffers:[AVAudioPCMBuffer] = [AVAudioPCMBuffer]()

let engine = AVAudioEngine()
let playerNode:AVAudioPlayerNode = AVAudioPlayerNode()

for i in 0 ..< numBuffers {
    let buffer = AVAudioPCMBuffer(PCMFormat: format, frameCapacity: samplesPerBuffer)
    buffers.append(buffer)
}

engine.attachNode(playerNode)
engine.connect(playerNode, to: engine.mainMixerNode, format: format)

var error:NSError? = nil

try engine.start()

func play(frequency: Float32) {
    let unitVelocity = Float32(2.0 * M_PI / format.sampleRate)
    let freqVelocity = frequency * unitVelocity
    
    var sampleTime: Float32 = 0
    // Fill the buffer with new samples.
    let buffer = buffers[bufferIndex]
    let leftChannel = buffer.floatChannelData[0]
    let rightChannel = buffer.floatChannelData[1]
    for sampleIndex in 0 ..< Int(samplesPerBuffer) {
        let sample = sinf(freqVelocity * sampleTime)
        
        leftChannel[sampleIndex] = sample
        rightChannel[sampleIndex] = sample
        sampleTime += 1
    }
    buffer.frameLength = samplesPerBuffer
    
    // Schedule the buffer for playback and release it for reuse after
    // playback has finished.
    playerNode.scheduleBuffer(buffer, completionHandler: nil)
    
    bufferIndex = (bufferIndex + 1) % buffers.count
    playerNode.play()
}

play(440.0)

