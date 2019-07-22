from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import argparse
import os.path
import sys
import time
from six.moves import xrange  
import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data
import math
import numpy as np 
import struct
NUM_CLASSES = 10
IMAGE_SIZE = 28
IMAGE_PIXELS = IMAGE_SIZE * IMAGE_SIZE
FLAGS = None



def inference(images, hidden1_units):
  with tf.name_scope('nodes_hidden1'):
    weights1 = tf.Variable(tf.truncated_normal([IMAGE_PIXELS, hidden1_units],stddev=1.0 / math.sqrt(float(IMAGE_PIXELS)), dtype=tf.float32),name='weights1')
    biases1 = tf.Variable(tf.zeros([hidden1_units], dtype=tf.float32),name='biases1')
    hidden1 = tf.nn.relu(tf.matmul(images, weights1) + biases1)
    
  with tf.name_scope('nodes_output_layer'):
    weightso = tf.Variable(tf.truncated_normal([hidden1_units, NUM_CLASSES],stddev=1.0 / math.sqrt(float(hidden1_units)), dtype=tf.float32),name='weightso')
    biaseso = tf.Variable(tf.zeros([NUM_CLASSES], dtype=tf.float32),name='biaseso')
    logits = tf.matmul(hidden1, weightso) + biaseso
  return logits

def loss_(logits, labels):
  cross_entropy = tf.nn.sparse_softmax_cross_entropy_with_logits(labels=labels, logits=logits, name='xentropy')
  return tf.reduce_mean(cross_entropy, name='xentropy_mean')

def training(loss, learning_rate):
  tf.summary.scalar('loss', loss)
  optimizer = tf.train.GradientDescentOptimizer(learning_rate)
  global_step = tf.Variable(0, name='global_step', trainable=False)
  train_op = optimizer.minimize(loss, global_step=global_step)
  return train_op

def evaluation(logits, labels):
  logits = tf.cast(logits, tf.float32)
  correct = tf.nn.in_top_k(logits, labels, 1)
  return tf.reduce_sum(tf.cast(correct, tf.int32))

def placeholder_inputs(batch_size):
  images_placeholder = tf.placeholder(tf.float32, shape=(batch_size, IMAGE_PIXELS))
  labels_placeholder = tf.placeholder(tf.int32, shape=(batch_size))
  return images_placeholder, labels_placeholder

def fill_feed_dict(data_set, images_pl, labels_pl):
  images_feed, labels_feed = data_set.next_batch(FLAGS.batch_size,FLAGS.fake_data)
  feed_dict = {images_pl: images_feed,labels_pl: labels_feed,}
  return feed_dict

def do_eval(sess,eval_correct,images_placeholder,labels_placeholder,data_set):
  true_count = 0 
  steps_per_epoch = data_set.num_examples // FLAGS.batch_size
  num_examples = steps_per_epoch * FLAGS.batch_size
  for step in xrange(steps_per_epoch):
    feed_dict = fill_feed_dict(data_set,images_placeholder,labels_placeholder)
    true_count += sess.run(eval_correct, feed_dict=feed_dict)
  precision = float(true_count) / num_examples
  print('  Num examples: %d  Num correct: %d  Precision @ 1: %0.04f' %(num_examples, true_count, precision))

def run_training():
  data_sets = input_data.read_data_sets(FLAGS.input_data_dir, FLAGS.fake_data)
  with tf.Graph().as_default():   
    images_placeholder, labels_placeholder = placeholder_inputs(FLAGS.batch_size)
    logits = inference(images_placeholder,FLAGS.hidden1)
    loss = loss_(logits, labels_placeholder)
    train_op = training(loss, FLAGS.learning_rate)
    eval_correct = evaluation(logits, labels_placeholder)
    summary = tf.summary.merge_all()
    init = tf.global_variables_initializer()
    saver = tf.train.Saver()
    sess = tf.Session()
    summary_writer = tf.summary.FileWriter(FLAGS.log_dir, sess.graph)
    sess.run(init)
    for step in xrange(FLAGS.max_steps):
      start_time = time.time()
      feed_dict = fill_feed_dict(data_sets.train,images_placeholder,labels_placeholder)
      _, loss_value = sess.run([train_op, loss],feed_dict=feed_dict)
      duration = time.time() - start_time
      if step % 100 == 0:
        print('Step %d: loss = %.2f (%.3f sec)' % (step, loss_value, duration))
        summary_str = sess.run(summary, feed_dict=feed_dict)
        summary_writer.add_summary(summary_str, step)
        summary_writer.flush()
      if (step + 1) % 1000 == 0 or (step + 1) == FLAGS.max_steps:
        checkpoint_file = os.path.join(FLAGS.log_dir, 'model.ckpt')
        saver.save(sess, checkpoint_file, global_step=step)
        print('Training Data Eval:')
        do_eval(sess,eval_correct,images_placeholder,labels_placeholder,data_sets.train)
        print('Validation Data Eval:')
        do_eval(sess,eval_correct,images_placeholder,labels_placeholder,data_sets.validation)
        print('Test Data Eval:')
        do_eval(sess,eval_correct,images_placeholder,labels_placeholder,data_sets.test)
        

    f_bin = open('parameter.txt', 'w')
    w_count = 0
    b_count = 0
    for v in tf.global_variables():
        if v.name.find('nodes_') != 0:
            continue
        shape = sess.run(tf.shape(v))
        value = sess.run(tf.transpose(v.value()))
        if len(shape) > 1:
            for v_ in value:
                for w in v_.tolist():
                    binary_value = struct.pack('f', w)
                    binary_str = ''.join('{:02x}'.format(x) for x in reversed(binary_value))
                    f_bin.write('%s ' % binary_str)
                    w_count += 1
                f_bin.write('\n')
            f_bin.write('\n')
        elif len(shape) == 1:
            for v_ in value.tolist():
                binary_value = struct.pack('f', v_)
                binary_str = ''.join('{:02x}'.format(x) for x in reversed(binary_value))
                f_bin.write('%s ' % binary_str)
                b_count += 1
            f_bin.write('\n')
            f_bin.write('\n')
    f_bin.close()
    print('\n','-------------------------------------------------------')
    print('Neuron number in input  layer:',IMAGE_PIXELS)
    print('Neuron number in hidden layer:',FLAGS.hidden1)
    print('Neuron number in output layer:',NUM_CLASSES)
    print('Weight number                :',w_count)
    print('Bias   number                :',b_count)
    
def main(_):
  np.set_printoptions(suppress=True)  
  if tf.gfile.Exists(FLAGS.log_dir):
    tf.gfile.DeleteRecursively(FLAGS.log_dir)
  tf.gfile.MakeDirs(FLAGS.log_dir)
  run_training()
  # os.system("pause")
  


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.add_argument(
      '--learning_rate',
      type=float,
      default=0.5,
      help='Initial learning rate.'
  )
  parser.add_argument(
      '--max_steps',
      type=int,
      default=5000,
      help='Number of steps to run trainer.'
  )
  parser.add_argument(
      '--hidden1',
      type=int,
      default=30,
      help='Number of units in hidden layer 1.'
  )

  parser.add_argument(
      '--batch_size',
      type=int,
      default=500,
      help='Batch size.  Must divide evenly into the dataset sizes.'
  )
  parser.add_argument(
      '--input_data_dir',
      type=str,
      default='/tmp/tensorflow/mnist/input_data',
      help='Directory to put the input data.'
  )
  parser.add_argument(
      '--log_dir',
      type=str,
      default='/tmp/tensorflow/mnist/logs/fully_connected_feed',
      help='Directory to put the log data.'
  )
  parser.add_argument(
      '--fake_data',
      default=False,
      help='If true, uses fake data for unit testing.',
      action='store_true'
  )

  FLAGS, unparsed = parser.parse_known_args()
  tf.app.run(main=main, argv=[sys.argv[0]] + unparsed)
